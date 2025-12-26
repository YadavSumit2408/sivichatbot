import '../model/message_model.dart';

class ChatState {
  final Map<String, List<MessageModel>> messagesByUser;
  final List<MessageModel> messages;
  final bool isLoading;
  final String? currentUserId;

  const ChatState({
    required this.messagesByUser,
    required this.messages,
    required this.isLoading,
    this.currentUserId,
  });

  factory ChatState.initial() {
    return const ChatState(
      messagesByUser: {},
      messages: [],
      isLoading: false,
      currentUserId: null,
    );
  }

  ChatState copyWith({
    Map<String, List<MessageModel>>? messagesByUser,
    List<MessageModel>? messages,
    bool? isLoading,
    String? currentUserId,
  }) {
    return ChatState(
      messagesByUser: messagesByUser ?? this.messagesByUser,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}