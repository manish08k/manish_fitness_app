import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  final String title;

  const WorkoutPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "$title workouts coming soon!",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
