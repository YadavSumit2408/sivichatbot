import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository({required this.apiClient});

  Future<String> fetchReceiverMessage() async {
    try {
      final response = await apiClient.get(ApiConstants.randomQuoteEndpoint);
      return response['content'] as String;
    } catch (e) {
      print('Error fetching receiver message: $e');
      final fallbackMessages = [
        'That\'s interesting!',
        'Tell me more about that.',
        'I see what you mean.',
        'That makes sense.',
        'Interesting perspective!',
      ];
      return fallbackMessages[DateTime.now().millisecond % fallbackMessages.length];
    }
  }

  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    try {
      final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        }
      }
      throw Exception('Word not found');
    } catch (e) {
      print('Error fetching word meaning: $e');
      throw Exception('Failed to fetch meaning');
    }
  }
}