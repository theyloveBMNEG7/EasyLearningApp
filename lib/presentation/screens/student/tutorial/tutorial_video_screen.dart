import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TutorialVideoScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const TutorialVideoScreen({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<TutorialVideoScreen> createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
        }
      }).catchError((e) {
        setState(() => _hasError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller.value.isPlaying;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: _hasError
            ? const Text(
                'Failed to load video.',
                style: TextStyle(color: Colors.white),
              )
            : _isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller),
                          if (!isPlaying)
                            const Icon(Icons.play_circle_filled,
                                size: 64, color: Colors.white70),
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                setState(() {
                  isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
