import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/charaterViewModel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];

  void _sendMessage(String text, {bool isMe = true}) {
    setState(() {
      messages.add({"text": text, "isMe": isMe});
    });

    // auto scroll xuống cuối
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final callVM = context.watch<CallViewModel>();
    final c = callVM.selectedCharacter;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(c?.image ?? ""),
              radius: 18,
            ),
            const SizedBox(width: 8),
            Text(c?.name ?? "Unknown"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              final callVM = context.read<CallViewModel>();
              if (c != null) {
                callVM.selectCharacter(c); // chọn user đang chat
                Navigator.pushNamed(
                  context,
                  '/setTime',
                  arguments: {'callType': 'phone'},
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              final callVM = context.read<CallViewModel>();
              if (c != null) {
                callVM.selectCharacter(c); // chọn user đang chat
                Navigator.pushNamed(
                  context,
                  '/setTime',
                  arguments: {'callType': 'video'},
                );
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"] as bool;
                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.redAccent : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.black.withValues(alpha: 0.4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isEmpty) return;
                      _sendMessage(text.trim(), isMe: true);
                      _controller.clear();

                      // fake reply
                      Future.delayed(const Duration(seconds: 1), () {
                        _sendMessage(
                            "${c?.name ?? "AI"}: mình vừa nhận tin nhắn của bạn 😁",
                            isMe: false);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    _sendMessage(text, isMe: true);
                    _controller.clear();

                    // fake reply
                    Future.delayed(const Duration(seconds: 1), () {
                      _sendMessage(
                          "${c?.name ?? "AI"}: mình vừa nhận tin nhắn của bạn 😁",
                          isMe: false);
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
