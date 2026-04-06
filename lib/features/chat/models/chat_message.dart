enum MessageSender { user, ai }

class ChatMessage {
  final int? id;
  final int? sessionId;
  final MessageSender sender;
  final String message;
  final String? imageUrl;
  final String? localImagePath;
  final String? audioUrl;
  final String? localAudioPath;
  final String? wolframImage;   // ← NEW
  final DateTime? createdAt;
  final bool isLoading;

  const ChatMessage({
    this.id,
    this.sessionId,
    required this.sender,
    required this.message,
    this.imageUrl,
    this.localImagePath,
    this.audioUrl,
    this.localAudioPath,
    this.wolframImage,           // ← NEW
    this.createdAt,
    this.isLoading = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'https://mathapi.dsrt321.online';

    String? _resolveUrl(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return raw.startsWith('http') ? raw : '$baseUrl$raw';
    }

    return ChatMessage(
      id: json['id'],
      sessionId: json['session'],
      sender: json['sender'] == 'USER' ? MessageSender.user : MessageSender.ai,
      message: json['message'] ?? '',
      imageUrl: _resolveUrl(json['image'] as String?),
      audioUrl: _resolveUrl(json['audio'] as String?),
      wolframImage: _resolveUrl(json['wolfram_image'] as String?), // ← NEW
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  factory ChatMessage.localUser({
    required String message,
    String? localImagePath,
    String? localAudioPath,
  }) {
    return ChatMessage(
      sender: MessageSender.user,
      message: message,
      localImagePath: localImagePath,
      localAudioPath: localAudioPath,
      createdAt: DateTime.now(),
    );
  }

  factory ChatMessage.aiLoading() {
    return const ChatMessage(
      sender: MessageSender.ai,
      message: '',
      isLoading: true,
    );
  }
}