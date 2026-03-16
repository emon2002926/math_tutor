import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/api_service.dart';
import '../../core/utils/storege_service.dart';
import '../models/chat_message.dart';


class ChatController extends GetxController {
  final apiServices = Get.find<ApiServices>();

  // ── Image picker ───────────────────────────────────────
  final ImagePicker _picker = ImagePicker();
  final selectedImage = Rxn<File>();

  // ── Text controller ────────────────────────────────────
  final textController = TextEditingController();

  // ── Messages displayed in chat ─────────────────────────
  final messages = <ChatMessage>[].obs;

  // ── Session (null = guest mode) ────────────────────────
  final sessionId = Rxn<int>();

  // ── States ─────────────────────────────────────────────
  final isSending = false.obs;
  final isCreatingSession = false.obs;

  // ── Chat sessions list (for drawer History) ────────────
  final chatSessions = <Map<String, dynamic>>[].obs;
  final isLoadingSessions = false.obs;

  // ── Auth helpers ───────────────────────────────────────
  bool get isLoggedIn => StorageService.accessToken != null;
  String? get _token => StorageService.accessToken;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) {
      // _createNewSession();
      // fetchChatSessions();
      if (isLoggedIn) {
        fetchChatSessions();   // only load history, no session created yet
      }
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // ════════════════════════════════════════════════════════
  // SESSION MANAGEMENT
  // ════════════════════════════════════════════════════════

  /// Creates a brand-new session on the server and clears messages.
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
      messages.clear();
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isCreatingSession.value = false;
    }
  }

  /// Called from the drawer "New Chat" button.
  // Future<void> startNewChat() async {
  //   if (isLoggedIn) {
  //     await _createNewSession();
  //   } else {
  //     messages.clear();
  //     sessionId.value = null;
  //   }
  // }

  Future<void> startNewChat() async {
    // same behavior for both logged-in and guest:
    // just clear the screen, session will be created on first send
    messages.clear();
    sessionId.value = null;
  }


  /// Fetch all sessions for the History section in the drawer.
  Future<void> fetchChatSessions() async {
    if (!isLoggedIn) return;
    isLoadingSessions.value = true;
    try {
      final response = await apiServices.get(
        '/api/chat/sessions/',
        headers: {'Authorization': 'Bearer $_token'},
      );
      final results = response['results'] as List<dynamic>;
      chatSessions.value =
          results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isLoadingSessions.value = false;
    }
  }

  /// Tap a history item to reload that session's messages.
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


  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  void removeImage() => selectedImage.value = null;



  Future<void> sendMessage() async {
    final text = textController.text.trim();
    final image = selectedImage.value;
    if (text.isEmpty && image == null) return;

    // 1. Show user bubble immediately (optimistic)
    messages.add(ChatMessage.localUser(
      message: text,
      localImagePath: image?.path,
    ));

    // 2. Show AI "typing…" placeholder
    messages.add(ChatMessage.aiLoading());

    // 3. Clear input
    textController.clear();
    selectedImage.value = null;
    isSending.value = true;

    try {
      if (isLoggedIn) {
        await _sendAuthenticated(text, image);
      } else {
        await _sendGuest(text, image);
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

  Future<void> _sendAuthenticated(String text, File? image) async {
    if (sessionId.value == null) await _createNewSession();
    final id = sessionId.value!;
    final endpoint = '/api/chat/sessions/$id/send/';
    final authHeader = {'Authorization': 'Bearer $_token'};

    dynamic response;

    if (image != null) {
      response = await _multipartPost(
        endpoint: endpoint,
        extraHeaders: authHeader,
        image: image,
        text: text,
      );
    } else {
      response = await apiServices.post(
        endpoint,
        headers: authHeader,
        body: {'message': text},
      );
    }

    // Replace local user bubble with server's user message
    _replaceLocalUserMessage(
      ChatMessage.fromJson(response['user_message'] as Map<String, dynamic>),
    );

    // Replace loading bubble with server's AI message
    _replaceLoadingBubble(
      ChatMessage.fromJson(response['ai_response'] as Map<String, dynamic>),
    );

    fetchChatSessions(); // refresh history list
  }

  // ── Guest ──────────────────────────────────────────────
  Future<void> _sendGuest(String text, File? image) async {
    const endpoint = '/api/chat/guest/';
    dynamic response;

    if (image != null) {
      response = await _multipartPost(
        endpoint: endpoint,
        image: image,
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

  Future<dynamic> _multipartPost({
    required String endpoint,
    Map<String, String>? extraHeaders,
    required File image,
    String text = '',
  }) async {
    final url = Uri.parse('${apiServices.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll({'Accept': 'application/json', ...?extraHeaders})
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
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
      if (messages[i].sender == MessageSender.user && messages[i].id == null) {
        messages[i] = serverMsg;
        break;
      }
    }
  }

  void _removeLoadingBubble() => messages.removeWhere((m) => m.isLoading);



  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail'] ??
          decoded['message'] ??
          decoded['error'] ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(12),
    );
  }
}