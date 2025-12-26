import 'dart:convert';
import 'dart:io';
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
      // Try with HTTP client that bypasses some DNS issues
      final httpClient = HttpClient();
      httpClient.connectionTimeout = const Duration(seconds: 10);
      
      final url = Uri.parse('$baseUrl$endpoint');
      print('ApiClient: Making GET request to: $url');
      
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
      );
      
      print('ApiClient: Response Status: ${response.statusCode}');
      print('ApiClient: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('ApiClient: Decoded response: $decoded');
        return decoded;
      } else {
        print('ApiClient: Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('ApiClient Network Error: No Internet connection - $e');
      throw Exception('No Internet connection. Please check your network settings.');
    } catch (e, stackTrace) {
      print('ApiClient Error: $e');
      print('ApiClient Stack trace: $stackTrace');
      rethrow;
    }
  }
}