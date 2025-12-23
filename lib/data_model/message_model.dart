enum MessageType { text, image, video }

class Message {
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final String senderId;
  final String senderName;

  Message({
    required this.type,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderName,
  });
}
