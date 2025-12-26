// lib/features/users/cubit/users_cubit.dart
import 'package:bloc/bloc.dart';
import 'users_state.dart';
import '../model/user_model.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState(users: []));

  // Adds a new user to the list
  void addUser(String name) {
    final updatedUsers = List<UserModel>.from(state.users)
      ..add(UserModel(name: name));

    emit(state.copyWith(users: updatedUsers));
  }
}
