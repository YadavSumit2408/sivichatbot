import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../model/message_model.dart';
import '../repository/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(ChatState.initial()) {
    _loadMessages();
  }

  static const String _messagesKey = 'saved_messages';

  // Load messages from SharedPreferences
  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_messagesKey);
      
      if (messagesJson != null) {
        final Map<String, dynamic> decoded = json.decode(messagesJson);
        final Map<String, List<MessageModel>> messagesByUser = {};
        
        decoded.forEach((userId, messages) {
          messagesByUser[userId] = (messages as List)
              .map((json) => MessageModel.fromJson(json))
              .toList();
        });
        
        emit(state.copyWith(messagesByUser: messagesByUser));
        print('Loaded messages for ${messagesByUser.length} users');
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> toSave = {};
      
      state.messagesByUser.forEach((userId, messages) {
        toSave[userId] = messages.map((m) => m.toJson()).toList();
      });
      
      final messagesJson = json.encode(toSave);
      await prefs.setString(_messagesKey, messagesJson);
      print('Saved messages to storage');
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  void loadMessagesForUser(String userId) {
    final userMessages = state.messagesByUser[userId] ?? [];
    emit(state.copyWith(
      messages: userMessages,
      currentUserId: userId,
    ));
  }

  Future<void> sendMessage(String text, String userId) async {
    if (state.isLoading) return;

    final senderMessage = MessageModel(
      id: _generateId(),
      text: text,
      type: MessageType.sender,
      timestamp: DateTime.now(),
      userId: userId,
    );

    final updatedMessages = [...state.messages, senderMessage];
    
    final updatedMessagesByUser = Map<String, List<MessageModel>>.from(state.messagesByUser);
    updatedMessagesByUser[userId] = updatedMessages;

    emit(state.copyWith(
      messages: updatedMessages,
      messagesByUser: updatedMessagesByUser,
      isLoading: true,
    ));

    await _saveMessages();

    try {
      final reply = await repository.fetchReceiverMessage();

      final receiverMessage = MessageModel(
        id: _generateId(),
        text: reply,
        type: MessageType.receiver,
        timestamp: DateTime.now(),
        userId: userId,
      );

      final finalMessages = [...updatedMessages, receiverMessage];
      updatedMessagesByUser[userId] = finalMessages;

      emit(state.copyWith(
        messages: finalMessages,
        messagesByUser: updatedMessagesByUser,
        isLoading: false,
      ));

      await _saveMessages();
    } catch (e) {
      print('Error fetching receiver message: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    return await repository.fetchWordMeaning(word);
  }

  MessageModel? getLastMessageForUser(String userId) {
    final messages = state.messagesByUser[userId];
    if (messages == null || messages.isEmpty) return null;
    return messages.last;
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}