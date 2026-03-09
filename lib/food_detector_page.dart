import 'package:flutter/material.dart';

class FoodDetectorPage extends StatelessWidget {
  const FoodDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Calorie Detector")),
      body: const Center(
        child: Text(
          "Camera-based Food Detection Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
