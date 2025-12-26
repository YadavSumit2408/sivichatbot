// lib/features/chat/model/message_model.dart
enum MessageType { sender, receiver }

class MessageModel {
  final String text;
  final MessageType type;

  const MessageModel({
    required this.text,
    required this.type,
  });

  bool get isSender => type == MessageType.sender;
}
