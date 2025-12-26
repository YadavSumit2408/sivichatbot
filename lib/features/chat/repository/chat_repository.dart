// lib/features/chat/repository/chat_repository.dart
import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository({required this.apiClient});

  // Fetches a random receiver message from public API
  Future<String> fetchReceiverMessage() async {
    final response = await apiClient.get(ApiConstants.randomQuoteEndpoint);
    return response['content'] as String;
  }
}
