enum MessageSender { user, ai }

class ChatMessage {
  final int? id;
  final int? sessionId;
  final MessageSender sender;
  final String message;
  final String? imageUrl;
  final String? localImagePath;
  final String? audioUrl;
  final String? localAudioPath;  // ← ADD THIS
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
    this.localAudioPath,         // ← ADD THIS
    this.createdAt,
    this.isLoading = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'https://mathapi.dsrt321.online';

    String? rawImage = json['image'] as String?;
    String? fullImageUrl = (rawImage != null && rawImage.isNotEmpty)
        ? (rawImage.startsWith('http') ? rawImage : '$baseUrl$rawImage')
        : null;

    String? rawAudio = json['audio'] as String?;
    String? fullAudioUrl = (rawAudio != null && rawAudio.isNotEmpty)
        ? (rawAudio.startsWith('http') ? rawAudio : '$baseUrl$rawAudio')
        : null;

    return ChatMessage(
      id: json['id'],
      sessionId: json['session'],
      sender: json['sender'] == 'USER' ? MessageSender.user : MessageSender.ai,
      message: json['message'] ?? '',
      imageUrl: fullImageUrl,
      audioUrl: fullAudioUrl,   // ← now a full URL
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  factory ChatMessage.localUser({
    required String message,
    String? localImagePath,
    String? localAudioPath,      // ← ADD THIS
  }) {
    return ChatMessage(
      sender: MessageSender.user,
      message: message,
      localImagePath: localImagePath,
      localAudioPath: localAudioPath,  // ← ADD THIS
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