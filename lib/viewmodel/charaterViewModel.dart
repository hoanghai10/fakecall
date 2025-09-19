import 'dart:async';
import 'package:flutter/material.dart';
import '../model/characterModel.dart';

class CallViewModel extends ChangeNotifier {
  final List<Character> _characters = [
    Character(name: "Call1", video: "assets/call1.mp4", image: "assets/fakecall1.png"),
    Character(name: "Call2", video: "assets/call2.mp4", image: "assets/fakecall2.jpg"),
  ];

  Character? _selectedCharacter;
  int _delaySeconds = 5;
  bool _isCalling = false;

  Timer? _callTimer;
  int _callDuration = 0;

  // getters
  List<Character> get characters => _characters;
  Character? get selectedCharacter => _selectedCharacter;
  int get delaySeconds => _delaySeconds;
  bool get isCalling => _isCalling;
  int get callDuration => _callDuration;

  // chọn nhân vật
  void selectCharacter(Character character) {
    _selectedCharacter = character;
    notifyListeners();
  }

  // set thời gian delay
  void setDelay(int seconds) {
    _delaySeconds = seconds;
    notifyListeners();
  }

  // bắt đầu cuộc gọi
  void startCall() {
    _isCalling = true;
    _startTimer();
    notifyListeners();
  }

  // kết thúc cuộc gọi
  void endCall() {
    _isCalling = false;
    _stopTimer();
    notifyListeners();
  }

  void _startTimer() {
    _callDuration = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _callTimer?.cancel();
    _callTimer = null;
    _callDuration = 0;
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }
}
