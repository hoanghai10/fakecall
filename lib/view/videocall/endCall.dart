import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/charaterViewModel.dart';

class EndCallPage extends StatelessWidget {
  const EndCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = context.watch<CallViewModel>();
    final character = callVM.selectedCharacter;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call_end, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              character == null
                  ? "Call Ended"
                  : "Call with ${character.name} ended",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text("Back to Character Select"),
            )
          ],
        ),
      ),
    );
  }
}
