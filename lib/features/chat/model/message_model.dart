enum MessageType { sender, receiver }

class MessageModel {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final String userId;

  const MessageModel({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.userId,
  });

  bool get isSender => type == MessageType.sender;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type == MessageType.sender ? 'sender' : 'receiver',
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      type: json['type'] == 'sender' ? MessageType.sender : MessageType.receiver,
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['userId'],
    );
  }
}