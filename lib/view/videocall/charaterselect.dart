import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/charaterViewModel.dart';

class CharacterSelectPage extends StatelessWidget {
  const CharacterSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = context.watch<CallViewModel>();
    final characters = callVM.characters;

    // nhận callType
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final callType = args?['callType'] ?? 'video';

    return Scaffold(
      appBar: AppBar(title: Text("Select character for $callType")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final c = characters[index];
          return InkWell(
            onTap: () {
              callVM.selectCharacter(c);

              if (callType == 'chat') {
                // đi thẳng vào chat
                Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: {'user': c}, // truyền luôn character
                );
              } else {
                // còn lại thì đi qua SetTime
                Navigator.pushNamed(
                  context,
                  '/setTime',
                  arguments: {'callType': callType},
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(c.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  c.name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
