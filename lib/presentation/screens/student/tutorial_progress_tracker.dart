import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class TutorialProgressTracker extends StatefulWidget {
  final String tutorialId;
  final String videoUrl;

  const TutorialProgressTracker({
    super.key,
    required this.tutorialId,
    required this.videoUrl,
  });

  @override
  State<TutorialProgressTracker> createState() =>
      _TutorialProgressTrackerState();
}

class _TutorialProgressTrackerState extends State<TutorialProgressTracker> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isSaving = false;
  late Stopwatch _watchTimer;

  @override
  void initState() {
    super.initState();
    _watchTimer = Stopwatch();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.addListener(_trackProgress);
      });
  }

  void _trackProgress() async {
    if (!_controller.value.isInitialized || _isSaving) return;

    final duration = _controller.value.duration.inSeconds;
    final position = _controller.value.position.inSeconds;

    if (duration == 0 || position == 0) return;

    final progress = position / duration;

    // Start/stop timer based on playback
    if (_controller.value.isPlaying && !_watchTimer.isRunning) {
      _watchTimer.start();
    } else if (!_controller.value.isPlaying && _watchTimer.isRunning) {
      _watchTimer.stop();
    }

    // Save progress every 10 seconds of playback
    if (position % 10 == 0 && progress >= 0.05 && progress <= 1.0) {
      _isSaving = true;
      await _saveProgress(progress);
      _isSaving = false;
    }
  }

  Future<void> _saveProgress(double progress) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('tutorial_progress')
        .doc('${userId}_${widget.tutorialId}');

    final doc = await docRef.get();
    final existingDuration = doc.data()?['durationWatched'] ?? 0;
    final newDuration = existingDuration + _watchTimer.elapsed.inSeconds;

    await docRef.set({
      'userId': userId,
      'tutorialId': widget.tutorialId,
      'progress': progress,
      'lastUpdated': FieldValue.serverTimestamp(),
      'durationWatched': newDuration,
    }, SetOptions(merge: true));

    _watchTimer.reset();
  }

  @override
  void dispose() {
    _controller.removeListener(_trackProgress);
    _controller.pause();
    _watchTimer.stop();
    _saveProgress(_controller.value.position.inSeconds /
        (_controller.value.duration.inSeconds == 0
            ? 1
            : _controller.value.duration.inSeconds));
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 48,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
