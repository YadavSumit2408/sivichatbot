// lib/features/chat/cubit/chat_state.dart
import '../model/message_model.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;

  const ChatState({
    required this.messages,
    required this.isLoading,
  });

  factory ChatState.initial() {
    return const ChatState(messages: [], isLoading: false);
  }

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
