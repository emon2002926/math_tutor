import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../core/services/api_services.dart';
import '../../core/util/storage_service.dart';
import '../../core/widgets/snakbar/custom_snackbar.dart';
import '../models/chat_message.dart';
import 'package:http_parser/http_parser.dart';
import 'package:record/record.dart';

class ChatController extends GetxController {
  final apiServices = Get.find<ApiServices>();

  final ImagePicker _picker = ImagePicker();
  final selectedImage = Rxn<File>();

  final _audioRecorder = AudioRecorder();
  final isRecording = false.obs;
  final selectedAudio = Rxn<File>();

  final textController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final sessionId = Rxn<int>();
  final isSending = false.obs;
  final isCreatingSession = false.obs;
  final chatSessions = <Map<String, dynamic>>[].obs;
  final isLoadingSessions = false.obs;

  bool get isLoggedIn => StorageService.accessToken != null;
  String? get _token => StorageService.accessToken;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) fetchChatSessions();
  }

  @override
  void onClose() {
    textController.dispose();
    _audioRecorder.dispose();
    super.onClose();
  }

  // ── Recording ────────────────────────────────────────────────────────────

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      _showError('Microphone permission denied');
      return;
    }
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    isRecording.value = true;
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    isRecording.value = false;
    if (path != null) {
      selectedAudio.value = File(path);
    }
  }

  void removeAudio() => selectedAudio.value = null;

  // ── Image Picker ─────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  void removeImage() => selectedImage.value = null;

  // ── Send Message ─────────────────────────────────────────────────────────

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    final image = selectedImage.value;
    final audio = selectedAudio.value;
    if (text.isEmpty && image == null && audio == null) return;

    messages.add(ChatMessage.localUser(
      message: text,
      localImagePath: image?.path,
      localAudioPath: audio?.path,
    ));
    messages.add(ChatMessage.aiLoading());

    textController.clear();
    selectedImage.value = null;
    selectedAudio.value = null;
    isSending.value = true;

    try {
      if (isLoggedIn) {
        await _sendAuthenticated(text, image, audio);
      } else {
        await _sendGuest(text, image, audio);
      }
    } on HttpException catch (e) {
      _removeLoadingBubble();
      _showError(_parseError(e));
    } catch (e) {
      _removeLoadingBubble();
      _showError('Something went wrong. Please try again.');
    } finally {
      isSending.value = false;
    }
  }

  // ── Authenticated Send ───────────────────────────────────────────────────

  Future<void> _sendAuthenticated(
      String text, File? image, File? audio) async {
    if (sessionId.value == null) await _createNewSession();
    final id = sessionId.value!;
    final endpoint = '/api/chat/sessions/$id/send/';
    final authHeader = {'Authorization': 'Bearer $_token'};

    dynamic response;

    if (image != null || audio != null) {
      response = await _multipartPost(
        endpoint: endpoint,
        extraHeaders: authHeader,
        image: image,
        audio: audio,
        text: text,
      );
    } else {
      response = await apiServices.post(
        endpoint,
        headers: authHeader,
        body: {'message': text},
      );
    }

    _replaceLocalUserMessage(
      ChatMessage.fromJson(
          response['user_message'] as Map<String, dynamic>),
    );
    _replaceLoadingBubble(
      ChatMessage.fromJson(
          response['ai_response'] as Map<String, dynamic>),
    );
    fetchChatSessions();
  }

  // ── Guest Send ───────────────────────────────────────────────────────────

  Future<void> _sendGuest(
      String text, File? image, File? audio) async {
    const endpoint = '/api/chat/guest/';
    dynamic response;

    if (image != null || audio != null) {
      response = await _multipartPost(
        endpoint: endpoint,
        image: image,
        audio: audio,
        text: text,
      );
    } else {
      response = await apiServices.post(
        endpoint,
        body: {'message': text},
      );
    }

    _replaceLoadingBubble(ChatMessage(
      sender: MessageSender.ai,
      message: response['ai_response'] as String? ?? '',
      createdAt: DateTime.now(),
    ));
  }

  // ── Multipart Upload ─────────────────────────────────────────────────────

  Future<dynamic> _multipartPost({
    required String endpoint,
    Map<String, String>? extraHeaders,
    File? image,
    File? audio,
    String text = '',
  }) async {
    final url = Uri.parse('${apiServices.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Accept': 'application/json',
        ...?extraHeaders,
      });

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', image.path));
    }
    if (audio != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        audio.path,
        contentType: MediaType('audio', 'm4a'),
      ));
    }
    if (text.isNotEmpty) request.fields['message'] = text;

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw HttpException(
        message: 'Upload failed',
        statusCode: res.statusCode,
        uri: url,
        body: res.body,
      );
    }
    return res.body.isEmpty ? null : jsonDecode(res.body);
  }

  // ── Session Management ───────────────────────────────────────────────────

  Future<void> _createNewSession() async {
    if (!isLoggedIn) return;
    isCreatingSession.value = true;
    try {
      final response = await apiServices.post(
        '/api/chat/sessions/',
        headers: {'Authorization': 'Bearer $_token'},
        body: {},
      );
      sessionId.value = response['id'] as int;
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isCreatingSession.value = false;
    }
  }

  Future<void> startNewChat() async {
    messages.clear();
    sessionId.value = null;
  }

  Future<void> fetchChatSessions() async {
    if (!isLoggedIn) return;
    isLoadingSessions.value = true;
    try {
      final response = await apiServices.get(
        '/api/chat/sessions/',
        headers: {'Authorization': 'Bearer $_token'},
      );
      final results = response['results'] as List<dynamic>;
      chatSessions.value = results
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isLoadingSessions.value = false;
    }
  }

  Future<void> loadSession(int id) async {
    if (!isLoggedIn) return;
    try {
      final response = await apiServices.get(
        '/api/chat/sessions/$id',
        headers: {'Authorization': 'Bearer $_token'},
      );
      sessionId.value = id;
      final rawMessages = response['messages'] as List<dynamic>;
      messages.value = rawMessages
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();
    } on HttpException catch (e) {
      _showError(_parseError(e));
    }
  }

  Future<void> deleteSession(int id) async {
    if (!isLoggedIn) return;
    try {
      await apiServices.delete(
        '/api/chat/sessions/$id/',
        headers: {'Authorization': 'Bearer $_token'},
      );
      chatSessions.removeWhere((s) => s['id'] == id);
      if (sessionId.value == id) {
        sessionId.value = null;
        messages.clear();
      }
      CustomSnackBar.success('Chat deleted');
    } on HttpException catch (e) {
      CustomSnackBar.error(_parseError(e));
    } catch (_) {
      CustomSnackBar.error('Something went wrong. Please try again.');
    }
  }

  Future<void> renameSession(int id, String newTitle) async {
    if (!isLoggedIn) return;
    try {
      await apiServices.put(
        '/api/chat/sessions/$id/',
        headers: {'Authorization': 'Bearer $_token'},
        body: {'title': newTitle},
      );
      final idx = chatSessions.indexWhere((s) => s['id'] == id);
      if (idx != -1) {
        chatSessions[idx] = {
          ...chatSessions[idx],
          'title': newTitle,
        };
      }
      CustomSnackBar.success('Chat renamed');
    } on HttpException catch (e) {
      CustomSnackBar.error(_parseError(e));
    } catch (_) {
      CustomSnackBar.error('Something went wrong. Please try again.');
    }
  }

  // ── Internal Helpers ─────────────────────────────────────────────────────

  void _replaceLoadingBubble(ChatMessage aiMsg) {
    final idx = messages.lastIndexWhere((m) => m.isLoading);
    if (idx != -1) {
      messages[idx] = aiMsg;
    } else {
      messages.add(aiMsg);
    }
  }

  void _replaceLocalUserMessage(ChatMessage serverMsg) {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].sender == MessageSender.user &&
          messages[i].id == null) {
        messages[i] = serverMsg;
        break;
      }
    }
  }

  void _removeLoadingBubble() =>
      messages.removeWhere((m) => m.isLoading);

  String _parseError(HttpException e) {
    try {
      final decoded =
      jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail'] ??
          decoded['message'] ??
          decoded['error'] ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  void _showError(String message) => CustomSnackBar.error(message);
}