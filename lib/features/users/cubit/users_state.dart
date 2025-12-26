// lib/features/users/cubit/users_state.dart
import '../model/user_model.dart';

class UsersState {
  final List<UserModel> users;

  const UsersState({required this.users});

  UsersState copyWith({List<UserModel>? users}) {
    return UsersState(
      users: users ?? this.users,
    );
  }
}
