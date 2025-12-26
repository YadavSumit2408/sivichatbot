// lib/features/chat/view/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/model/user_model.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../model/message_model.dart';

class ChatPage extends StatelessWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        children: [
          Expanded(child: _MessagesList()),
          _MessageInput(user: user),
        ],
      ),
    );
  }
}
class _MessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return ListView.builder(
          reverse: true,
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final message =
                state.messages[state.messages.length - 1 - index];
            return _MessageBubble(message: message);
          },
        );
      },
    );
  }
}
class _MessageBubble extends StatelessWidget {
  final MessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isSender ? Alignment.centerRight : Alignment.centerLeft;

    final color =
        message.isSender ? Colors.blue.shade100 : Colors.grey.shade200;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message.text),
      ),
    );
  }
}
class _MessageInput extends StatefulWidget {
  final UserModel user;

  const _MessageInput({required this.user});

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(hintText: 'Type a message'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;

              context.read<ChatCubit>().sendMessage(text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
