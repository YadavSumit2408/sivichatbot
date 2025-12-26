import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.baseUrl,
  });

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('API Request: GET $url');
      
      final response = await client.get(url);
      
      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Client Error: $e');
      rethrow;
    }
  }
}