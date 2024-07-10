// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> askQuestion(String question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ask-question'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'question': question}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['answer'];
    } else {
      throw Exception('Failed to get answer');
    }
  }
}
