import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';

import '../../viewmodel/charaterViewModel.dart';

class FakeVideoCallPage extends StatefulWidget {
  const FakeVideoCallPage({super.key});

  @override
  State<FakeVideoCallPage> createState() => _FakeVideoCallPageState();
}

class _FakeVideoCallPageState extends State<FakeVideoCallPage> {
  VideoPlayerController? _videoController;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _initFrontCamera();
  }

  void _initVideo() {
    final character = Provider.of<CallViewModel>(
      context,
      listen: false,
    ).selectedCharacter;

    if (character != null) {
      _videoController = VideoPlayerController.asset(character.video)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
          _videoController!.setLooping(true);
        });
    }
  }

  Future<void> _initFrontCamera() async {
    final cameras = await availableCameras();

    // 🔹 chọn camera trước (front camera)
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CallViewModel>().selectedCharacter;
    final callVM = context.watch<CallViewModel>();
    final duration = callVM.callDuration;
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final callType = args?['callType'] ?? 'video';

    return Scaffold(
      body: Stack(
        children: [
          // Nếu là video call thì hiển thị video
          if (callType == "video")
            Positioned.fill(
              child: _videoController != null &&
                  _videoController!.value.isInitialized
                  ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            )
          else
            Positioned.fill(
              child: character != null
                  ? Image.asset(
                character.image, // nhớ thêm field image trong model
                fit: BoxFit.cover,
              )
                  : const Center(child: Icon(Icons.person, size: 120, color: Colors.grey)),
            ),

          // Thời gian gọi
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "$minutes:$seconds",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          // Camera preview chỉ hiển thị khi là video call
          if (callType == "video")
            Positioned(
              right: 16,
              bottom: 100,
              child: _cameraController != null &&
                  _cameraController!.value.isInitialized
                  ? Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CameraPreview(_cameraController!),
                ),
              )
                  : const SizedBox(),
            ),

          // Nút End Call
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  context.read<CallViewModel>().endCall();
                  Navigator.pushReplacementNamed(
                    context,
                    '/endCall',
                    arguments: {"name": character?.name ?? ''},
                  );
                },
                child: const Text("End Call"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
