import 'package:flutter/material.dart';
import 'package:easylearningapp/presentation/widgets/live_class/pdf_viewer_box.dart';

class HostClassScreen extends StatelessWidget {
  const HostClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const samplePdfUrl =
        "https://www.africau.edu/images/default/sample.pdf"; // Replace with dynamic link later

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Live Class - Hosting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Share PDF',
            onPressed: () {
              // TODO: Upload PDF logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Camera Preview Placeholder
                Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: const Center(
                    child:
                        Icon(Icons.videocam, size: 80, color: Colors.white54),
                  ),
                ),
                // Bottom Control Bar
                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _controlButton(
                          icon: Icons.mic_off,
                          color: Colors.red,
                          onTap: () {
                            // TODO: Mute microphone
                          },
                        ),
                        _controlButton(
                          icon: Icons.flip_camera_ios,
                          color: Colors.blue,
                          onTap: () {
                            // TODO: Flip camera
                          },
                        ),
                        _controlButton(
                          icon: Icons.pause_circle,
                          color: Colors.orange,
                          onTap: () {
                            // TODO: Pause stream
                          },
                        ),
                        _controlButton(
                          icon: Icons.call_end,
                          color: Colors.red.shade800,
                          onTap: () {
                            // TODO: End class
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PDFViewerBox(pdfUrl: samplePdfUrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 26,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
        iconSize: 26,
        tooltip: icon.toString(),
      ),
    );
  }
}
