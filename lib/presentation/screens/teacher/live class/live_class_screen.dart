import 'package:flutter/material.dart';
import 'host_class_screen.dart';
import 'schedule_class_screen.dart';

class LiveClassScreen extends StatelessWidget {
  const LiveClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Live Class",
              style: TextStyle(fontSize: 25, color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.video_call), text: "Host Class"),
              Tab(icon: Icon(Icons.schedule), text: "Schedule Class"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HostClassScreen(),
            ScheduleClassScreen(),
          ],
        ),
      ),
    );
  }
}
