import 'package:flutter/material.dart';

class YogaPage extends StatelessWidget {
  const YogaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yoga Routines")),
      body: const Center(child: Text("Yoga Section Coming Soon!", style: TextStyle(fontSize: 24))),
    );
  }
}
