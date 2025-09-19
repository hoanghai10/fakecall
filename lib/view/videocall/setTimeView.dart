import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/notification_service.dart';
import '../../viewmodel/charaterViewModel.dart';

class SetTimePage extends StatelessWidget {
  const SetTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = context.watch<CallViewModel>();

    // Nhận callType từ màn trước
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final callType = args?['callType'] ?? 'video';

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Set Time Before ${callType == 'phone' ? 'Phone Call' : 'Video Call'}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF120935),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_set_time.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Delay: ${callVM.delaySeconds} seconds",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            Slider(
              value: callVM.delaySeconds.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: "${callVM.delaySeconds}s",
              onChanged: (val) {
                context.read<CallViewModel>().setDelay(val.toInt());
              },
            ),
            const SizedBox(height: 20),

            // Schedule bằng notification
            ElevatedButton(
              onPressed: () {
                final delay = callVM.delaySeconds;
                NotificationService().scheduleNotification(
                  id: 1,
                  title: "Incoming Call",
                  body: "Tap to answer",
                  delaySeconds: delay,
                  payload: "incoming_$callType", // bắn type vào payload
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Incoming $callType call scheduled in $delay seconds"),
                  ),
                );
              },
              child: Text("Schedule ${callType == 'phone' ? 'Phone Call' : 'Video Call'}"),
            ),

            const SizedBox(height: 20),

            // Chạy thẳng sau delay
            ElevatedButton(
              onPressed: () {
                final delay = callVM.delaySeconds;
                Future.delayed(Duration(seconds: delay), () {
                  Navigator.pushNamed(
                    context,
                    '/incoming',
                    arguments: {'callType': callType},
                  );
                });
              },
              child: Text("Start ${callType == 'phone' ? 'Phone Call' : 'Video Call'} Now"),
            ),
          ],
        ),
      ),
    );
  }
}
