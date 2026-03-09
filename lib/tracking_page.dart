import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progress Tracking")),
      body: const Center(
        child: Text(
          "Progress Charts & Logs Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
