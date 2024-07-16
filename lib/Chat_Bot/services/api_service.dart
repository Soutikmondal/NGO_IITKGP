import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:patient_app/Chat_Bot/constants/api_consts.dart';
import 'package:patient_app/Chat_Bot/models/chat_model.dart';

class ApiService {
  static Future<List<ChatModel>> sendMessage({required String message}) async {
    try {
      var response = await http.post(
        Uri.parse(
            "$BASE_URL/models/gemini-1.5-flash-latest:generateContent?key=$API_KEY"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': message,
                }
              ]
            }
          ],
        }),
      );

      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      String content =
          jsonResponse['candidates'][0]['content']['parts'][0]['text'];

      List<ChatModel> chatList = [
        ChatModel(msg: content, chatIndex: 1),
      ];

      return chatList;
    } catch (error) {
      log("Error sending message: $error");
      rethrow;
    }
  }
}
