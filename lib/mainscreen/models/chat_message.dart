enum MessageSender { user, ai }

class ChatMessage {
  final int? id;
  final int? sessionId;
  final MessageSender sender;
  final String message;
  final String? imageUrl;        // server-returned image URL
  final String? localImagePath;  // local path before upload
  final String? audioUrl;
  final DateTime? createdAt;
  final bool isLoading;          // AI "typing..." placeholder

  const ChatMessage({
    this.id,
    this.sessionId,
    required this.sender,
    required this.message,
    this.imageUrl,
    this.localImagePath,
    this.audioUrl,
    this.createdAt,
    this.isLoading = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'https://mathapi.dsrt321.online'; // ← your actual base URL

    String? rawImage = json['image'] as String?;
    String? fullImageUrl = (rawImage != null && rawImage.isNotEmpty)
        ? (rawImage.startsWith('http') ? rawImage : '$baseUrl$rawImage')
        : null;

    return ChatMessage(
      id: json['id'],
      sessionId: json['session'],
      sender: json['sender'] == 'USER' ? MessageSender.user : MessageSender.ai,
      message: json['message'] ?? '',
      imageUrl: fullImageUrl,   // ← now a full URL
      audioUrl: json['audio'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  factory ChatMessage.localUser({
    required String message,
    String? localImagePath,
  }) {
    return ChatMessage(
      sender: MessageSender.user,
      message: message,
      localImagePath: localImagePath,
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