// lib/features/chat/cubit/chat_cubit.dart
import 'package:bloc/bloc.dart';
import '../model/message_model.dart';
import '../repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(ChatState.initial());

  // Sends a local message and fetches a receiver reply
  Future<void> sendMessage(String text) async {
    final updatedMessages = List<MessageModel>.from(state.messages)
      ..add(MessageModel(text: text, type: MessageType.sender));

    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      final reply = await repository.fetchReceiverMessage();

      updatedMessages.add(
        MessageModel(text: reply, type: MessageType.receiver),
      );

      emit(
        state.copyWith(
          messages: updatedMessages,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
