import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

class FakeVideoCallPage extends StatefulWidget {
  final String characterVideo; // path video nhân vật
  const FakeVideoCallPage({super.key, required this.characterVideo});

  @override
  State<FakeVideoCallPage> createState() => _FakeVideoCallPageState();
}

class _FakeVideoCallPageState extends State<FakeVideoCallPage> {
  late VideoPlayerController _videoController;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    // play nhân vật
    _videoController = VideoPlayerController.asset(widget.characterVideo)
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      });

    // bật camera user
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Nhân vật (full screen video)
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // Camera user góc nhỏ
          Positioned(
            right: 16,
            top: 40,
            width: 120,
            height: 160,
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CameraPreview(_cameraController!),
            )
                : Container(color: Colors.black38),
          ),

          // Controls (timer + end call)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 32),
                  label: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
