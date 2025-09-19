import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/charaterViewModel.dart';

class IncomeCallPage extends StatelessWidget {
  const IncomeCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = context.watch<CallViewModel>();
    final character = callVM.selectedCharacter;
    //Nhận callType từ màn trước
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final callType = args?['callType'] ?? 'video';
    return Scaffold(
      backgroundColor: Colors.black,
      body: character == null
          ? const Center(
              child: Text(
                "No incoming call",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(character.image, fit: BoxFit.cover),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3), // thêm tối để nổi bật
                  ),
                ),

                /// Foreground content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(character.image),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${character.name} is calling...",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            heroTag: "rejectCall",
                            backgroundColor: Colors.red,
                            onPressed: () {
                              context.read<CallViewModel>().endCall();
                              Navigator.pushReplacementNamed(
                                context,
                                '/endCall',
                              );
                            },
                            child: const Icon(Icons.call_end),
                          ),
                          FloatingActionButton(
                            heroTag: "acceptCall",
                            backgroundColor: Colors.green,
                            onPressed: () {
                              context.read<CallViewModel>().startCall();
                              Navigator.pushReplacementNamed(
                                context,
                                '/fakeCall',
                                arguments: {
                                  "callType": callType,
                                },
                              );
                            },
                            child: const Icon(Icons.call),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
