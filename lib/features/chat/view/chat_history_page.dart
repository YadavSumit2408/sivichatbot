// lib/features/chat/view/chat_history_page.dart
import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('chat_history'),
      children: const [
        ListTile(
          leading: CircleAvatar(child: Text('U')),
          title: Text('No chats yet'),
          subtitle: Text('Start a conversation'),
        ),
      ],
    );
  }
}
