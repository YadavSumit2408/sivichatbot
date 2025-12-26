// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.baseUrl,
  });

  // Performs a GET request and returns decoded JSON
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ApiException(
      message: 'Request failed',
      statusCode: response.statusCode,
    );
  }
}
