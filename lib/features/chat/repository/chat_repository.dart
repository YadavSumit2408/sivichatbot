import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository({required this.apiClient});

  Future<String> fetchReceiverMessage() async {
    try {
      print('ChatRepository: Fetching message from API...');
      print('Base URL: ${ApiConstants.jsonPlaceholderBaseUrl}');
      print('Endpoint: ${ApiConstants.commentsEndpoint}');
      
      // Use JSONPlaceholder comments API
      final url = Uri.parse('${ApiConstants.jsonPlaceholderBaseUrl}${ApiConstants.commentsEndpoint}?postId=1');
      print('ChatRepository: Full URL: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timeout');
        },
      );
      
      print('ChatRepository: Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        if (data.isNotEmpty) {
          // Get a random comment from the list
          final randomIndex = DateTime.now().millisecond % data.length;
          final comment = data[randomIndex];
          final message = comment['body'] as String;
          
          // Clean up the message (remove newlines, trim)
          final cleanMessage = message.replaceAll('\n', ' ').trim();
          
          print('ChatRepository: Success! Message: $cleanMessage');
          return cleanMessage;
        } else {
          print('ChatRepository: Response is empty');
          throw Exception('Empty response');
        }
      } else {
        print('ChatRepository: Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('ChatRepository Network Error: $e');
      return _getFallbackMessage();
    } on TimeoutException catch (e) {
      print('ChatRepository Timeout Error: $e');
      return _getFallbackMessage();
    } catch (e, stackTrace) {
      print('ChatRepository Error: $e');
      print('Stack trace: $stackTrace');
      return _getFallbackMessage();
    }
  }

  String _getFallbackMessage() {
    final fallbackMessages = [
      'That\'s interesting!',
      'Tell me more about that.',
      'I see what you mean.',
      'That makes sense.',
      'Interesting perspective!',
      'How fascinating!',
      'I understand your point.',
      'That\'s a great observation.',
    ];
    
    final fallback = fallbackMessages[DateTime.now().millisecond % fallbackMessages.length];
    print('ChatRepository: Using fallback message: $fallback');
    return fallback;
  }

  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    try {
      print('Fetching meaning for word: $word');
      final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
      final response = await http.get(url);

      print('Dictionary API status: ${response.statusCode}');

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