import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/model/user_model.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../model/message_model.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadMessagesForUser(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                widget.user.initial,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.user.isOnline ? 'Online' : widget.user.lastSeenText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _MessagesList(user: widget.user)),
          _MessageInput(user: widget.user),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final UserModel user;

  const _MessagesList({required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading && state.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (state.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final message = state.messages[state.messages.length - 1 - index];
            return _MessageBubble(message: message, user: user);
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final UserModel user;

  const _MessageBubble({required this.message, required this.user});

  void _showWordMeaning(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WordMeaningSheet(word: word),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  user.initial,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: GestureDetector(
                onLongPress: () {
                  final words = message.text.split(' ');
                  if (words.isNotEmpty) {
                    _showWordMeaning(context, words.first);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isSender ? 16 : 4),
                      bottomRight: Radius.circular(isSender ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSender ? Colors.white : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSender
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isSender) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  'Y',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _WordMeaningSheet extends StatelessWidget {
  final String word;

  const _WordMeaningSheet({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<Map<String, dynamic>>(
        future: context.read<ChatCubit>().fetchWordMeaning(word),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Could not find meaning for "$word"',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final meanings = data['meanings'] as List? ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        word.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                if (data['phonetic'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data['phonetic'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ...meanings.map((meaning) {
                  final partOfSpeech = meaning['partOfSpeech'] ?? '';
                  final definitions = meaning['definitions'] as List? ?? [];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partOfSpeech,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...definitions.take(2).map((def) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    def['definition'] ?? '',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// THIS IS THE TEXT INPUT - IT WAS THERE BEFORE BUT HERE IT IS AGAIN
class _MessageInput extends StatefulWidget {
  final UserModel user;

  const _MessageInput({required this.user});

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(text, widget.user.id);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
child: Container(
decoration: BoxDecoration(
color: const Color(0xFFF4F5F7),
borderRadius: BorderRadius.circular(24),
),
child: TextField(
controller: _controller,

maxLines: null,
textCapitalization: TextCapitalization.sentences,
decoration: const InputDecoration(
hintText: 'Type a message...',
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(
horizontal: 20,
vertical: 12,
),
),
// onSubmitted: () => _sendMessage(),
),
),
),
const SizedBox(width: 8),
BlocBuilder<ChatCubit, ChatState>(
builder: (context, state) {
return Container(
decoration: const BoxDecoration(
color: Colors.green,
shape: BoxShape.circle,
),
child: IconButton(
icon: state.isLoading
? const SizedBox(
width: 20,
height: 20,
child: CircularProgressIndicator(
strokeWidth: 2,
valueColor:
AlwaysStoppedAnimation<Color>(Colors.white),
),
)
: const Icon(Icons.send_rounded),
color: Colors.white,
onPressed: state.isLoading ? null : _sendMessage,
),
);
},
),
],
),
),
);
}
}