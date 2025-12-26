// lib/features/users/view/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';
import '../model/user_model.dart';
import '../../chat/view/chat_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView.builder(
            key: const PageStorageKey('users_list'),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return _UserTile(user: user);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addUser(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Adds a mock user and shows confirmation
  void _addUser(BuildContext context) {
    final userName = 'User ${DateTime.now().millisecondsSinceEpoch % 1000}';
    context.read<UsersCubit>().addUser(userName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$userName added')),
    );
  }
}
class _UserTile extends StatelessWidget {
  final UserModel user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.initial),
      ),
      title: Text(user.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(user: user),
          ),
        );
      },
    );
  }
}
