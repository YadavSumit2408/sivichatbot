import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/cubit/users_cubit.dart';
import '../../users/cubit/users_state.dart';
import '../../users/model/user_model.dart';
import '../cubit/chat_cubit.dart';
import '../model/message_model.dart';
import '../view/chat_page.dart';

class ChatHistoryPage extends StatefulWidget {
  final ScrollController? scrollController;
  
  const ChatHistoryPage({super.key, this.scrollController});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, usersState) {
        // Get users with their last messages
        final List<Map<String, dynamic>> usersWithChatsData = [];
        
        for (var user in usersState.users) {
          final lastMessage = context.read<ChatCubit>().getLastMessageForUser(user.id);
          if (lastMessage != null) {
            usersWithChatsData.add({
              'user': user,
              'lastMessage': lastMessage,
            });
          }
        }

        // Sort by most recent message first
        usersWithChatsData.sort((a, b) {
          final MessageModel aMessage = a['lastMessage'] as MessageModel;
          final MessageModel bMessage = b['lastMessage'] as MessageModel;
          return bMessage.timestamp.compareTo(aMessage.timestamp);
        });

        if (usersWithChatsData.isEmpty) {
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
                  'No chat history',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a conversation with a user',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          key: const PageStorageKey('chat_history'),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: usersWithChatsData.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          itemBuilder: (context, index) {
            final data = usersWithChatsData[index];
            final UserModel user = data['user'] as UserModel;
            final MessageModel lastMessage = data['lastMessage'] as MessageModel;

            return Container(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    user.initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: Text(
                  _formatTime(lastMessage.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ChatCubit>(),
                        child: ChatPage(user: user),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${time.day}/${time.month}/${time.year}';
  }
}