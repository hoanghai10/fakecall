import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  /// Gọi Gemini và trả về text trả lời
  Future<String> sendMessage(String prompt) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Lỗi Gemini: ${response.body}");
    }
  }

  /// Hàm chat 2 chiều: nhận message user, trả luôn cả 2 messages (user + bot)
  Future<List<Map<String, dynamic>>> chat(String userMessage) async {
    final messages = <Map<String, dynamic>>[];

    // Add user message
    messages.add({
      "text": userMessage,
      "isMe": true,
      "time": "Now",
    });

    try {
      final reply = await sendMessage(userMessage);

      // Add AI reply
      messages.add({
        "text": reply,
        "isMe": false,
        "time": "Now",
      });
    } catch (e) {
      messages.add({
        "text": "⚠️ Lỗi gọi API: $e",
        "isMe": false,
        "time": "Now",
      });
    }

    return messages;
  }
}
