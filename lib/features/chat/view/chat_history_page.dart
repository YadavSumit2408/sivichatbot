import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/cubit/users_cubit.dart';
import '../../users/cubit/users_state.dart';
import '../cubit/chat_cubit.dart';
import '../view/chat_page.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, usersState) {
        final usersWithChats = usersState.users.where((user) {
          final lastMessage = context.read<ChatCubit>().getLastMessageForUser(user.id);
          return lastMessage != null;
        }).toList();

        if (usersWithChats.isEmpty) {
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
          key: const PageStorageKey('chat_history'),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: usersWithChats.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          itemBuilder: (context, index) {
            final user = usersWithChats[index];
            final lastMessage = context.read<ChatCubit>().getLastMessageForUser(user.id);

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
                subtitle: lastMessage != null
                    ? Padding(
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
                      )
                    : null,
                trailing: lastMessage != null
                    ? Text(
                        _formatTime(lastMessage.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      )
                    : null,
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