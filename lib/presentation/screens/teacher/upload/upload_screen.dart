import 'package:flutter/material.dart';
import 'tabs/upload_course_tab.dart';
import 'tabs/upload_correction_tab.dart';
import 'tabs/upload_video_tab.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload Content",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                fontFamily: 'OpenSans'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.book), text: "Courses"),
              Tab(icon: Icon(Icons.article), text: "Corrections"),
              Tab(icon: Icon(Icons.video_library), text: "Tutorials"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UploadCourseTab(),
            UploadCorrectionTab(),
            UploadVideoTab(),
          ],
        ),
      ),
    );
  }
}
