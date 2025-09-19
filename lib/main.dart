import 'package:flutter/material.dart';
import 'package:scall_carry/service/notification_service.dart';
import 'package:scall_carry/view/chat/chatview.dart';
import 'package:scall_carry/view/homeview.dart';
import 'package:scall_carry/view/videocall/charaterselect.dart';
import 'package:scall_carry/view/videocall/endCall.dart';
import 'package:scall_carry/view/videocall/fakecall.dart';
import 'package:scall_carry/view/videocall/incomeCall.dart';
import 'package:scall_carry/view/videocall/setTimeView.dart';
import 'package:provider/provider.dart';
import 'package:scall_carry/viewmodel/charaterViewModel.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();

  final launchDetails = await notificationService.getLaunchDetails();
  final initialRoute = (launchDetails?.didNotificationLaunchApp ?? false) &&
      launchDetails?.notificationResponse?.payload == "incoming"
      ? '/incoming'
      : '/';

  runApp(
    ChangeNotifierProvider(
      create: (_) => CallViewModel(),
      child: MaterialApp(
        title: 'Scary call',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        routes: {
          '/': (context) => const HomeView(),
          '/charaterSelect': (context) => const CharacterSelectPage(),
          '/setTime': (context) => const SetTimePage(),
          '/fakeCall' : (context) => const FakeVideoCallPage(),
          '/incoming': (context) => const IncomeCallPage(),
          '/endCall': (context) => const EndCallPage(),
          '/chat': (context) => const ChatScreen(),
        },
      ),
    ),
  );
}
