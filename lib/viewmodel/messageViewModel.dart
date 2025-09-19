import 'package:flutter/material.dart';
import '../service/ApiService.dart';
import '../model/characterModel.dart';

class ChatViewModel extends ChangeNotifier {
  final GeminiService _gemini;
  final Character user;

  ChatViewModel(this._gemini, this.user);

  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    inputController.clear();
    _messages.add({
      "text": text,
      "isMe": true,
      "time": "Now",
    });
    notifyListeners();

    final newMsgs = await _gemini.chat(text);

    _messages.addAll(newMsgs.where((m) => m["isMe"] == false));
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}
