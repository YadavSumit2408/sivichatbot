import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../model/user_model.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState.initial()) {
    _loadUsers();
  }

  static const String _usersKey = 'saved_users';

  // Load users from SharedPreferences on startup
  Future<void> _loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson != null) {
        final List<dynamic> decoded = json.decode(usersJson);
        final users = decoded.map((json) => UserModel.fromJson(json)).toList();
        emit(state.copyWith(users: users));
        print('Loaded ${users.length} users from storage');
      }
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  // Save users to SharedPreferences
  Future<void> _saveUsers(List<UserModel> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = json.encode(users.map((u) => u.toJson()).toList());
      await prefs.setString(_usersKey, usersJson);
      print('Saved ${users.length} users to storage');
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  // Add a new user
  Future<void> addUser(String name) async {
    final newUser = UserModel(
      id: _generateId(),
      name: name,
      isOnline: Random().nextBool(),
      lastSeen: DateTime.now().subtract(
        Duration(minutes: Random().nextInt(120)),
      ),
      createdAt: DateTime.now(),
    );

    final updatedUsers = [...state.users, newUser];
    emit(state.copyWith(users: updatedUsers));
    await _saveUsers(updatedUsers);
  }

  // Remove a user
  Future<void> removeUser(String id) async {
    final updatedUsers = state.users.where((user) => user.id != id).toList();
    emit(state.copyWith(users: updatedUsers));
    await _saveUsers(updatedUsers);
  }

  // Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}