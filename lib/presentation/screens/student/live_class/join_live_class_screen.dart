import 'package:flutter/material.dart';
import 'package:easylearningapp/presentation/widgets/live_class/pdf_viewer_box.dart';

class JoinLiveClassScreen extends StatelessWidget {
  const JoinLiveClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const samplePdfUrl =
        "https://www.africau.edu/images/default/sample.pdf"; // Replace with dynamic URL later

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Live Class"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open chat
            },
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Class Chat',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Video preview + class info container (fixed height)
              Container(
                color: Colors.black87,
                height: 220,
                child: Stack(
                  children: [
                    Center(
                      child:
                          Icon(Icons.videocam, size: 90, color: Colors.white54),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Subject: Software Engineering",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "Teacher: Mr. Emmanuel",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PDF Viewer takes the rest of the screen
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PDFViewerBox(pdfUrl: samplePdfUrl),
                ),
              ),
            ],
          ),

          // Leave button fixed at the bottom
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.call_end, color: Colors.white),
              label: const Text("Leave Class"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
