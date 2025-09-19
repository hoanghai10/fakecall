import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool musicBackground = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scary Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    menuCall(context, Icons.videocam, 'VIDEO CALL', 'video'),
                    menuCall(context, Icons.phone, 'PHONE CALL', 'phone'),
                    menuCall(context, Icons.chat, 'TEXT CHAT', 'chat'),
                    menuCall(context, Icons.mic, 'MY RECORDINGS', 'record'),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget menuCall(
  BuildContext context,
  IconData icon,
  String title,
  String callType,
) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        '/charaterSelect',
        arguments: {'callType': callType},
      );
    },
    child: Container(
      width: 156,
      height: 146,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/farme.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
