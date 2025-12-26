import '../model/user_model.dart';

class UsersState {
  final List<UserModel> users;
  final bool isLoading;
  final String? error;

  const UsersState({
    required this.users,
    required this.isLoading,
    this.error,
  });

  factory UsersState.initial() {
    return const UsersState(
      users: [],
      isLoading: false,
      error: null,
    );
  }

  UsersState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? error,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}