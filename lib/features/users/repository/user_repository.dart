import '../model/user_model.dart';
import '../../../core/network/api_client.dart';

class UsersRepository {
  final ApiClient apiClient;

  UsersRepository({required this.apiClient});

  // Fetches users from JSONPlaceholder API
  Future<List<UserModel>> fetchUsers({int limit = 20}) async {
    try {
      final response = await apiClient.get('/users');
      
      final List users = response is List ? response : [];
      final limitedUsers = users.take(limit).toList();

      return limitedUsers.map<UserModel>((json) {
        final isOnline = json['id'] % 3 == 0;

        return UserModel(
          id: json['id'].toString(),
          name: json['name'] ?? 'Unknown User',
          isOnline: isOnline,
          lastSeen: DateTime.now().subtract(
            Duration(minutes: json['id'] * 5),
          ),
          createdAt: DateTime.now(), // ADD THIS LINE
        );
      }).toList();
    } catch (e) {
      print('Error in fetchUsers: $e');
      rethrow;
    }
  }
}