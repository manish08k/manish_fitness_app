import 'dart:async';
import 'package:flutter/material.dart';



class ExerciseScreen extends StatefulWidget {
  final String title;
  final List<Map<String, String>> exercises;

  const ExerciseScreen({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int sets = 1;
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => seconds++);
    });
  }

  void pauseTimer() {
    isRunning = false;
    timer?.cancel();
  }

  void resetTimer() {
    pauseTimer();
    setState(() => seconds = 0);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int sec) {
    final minutes = (sec ~/ 60).toString().padLeft(2, '0');
    final remainder = (sec % 60).toString().padLeft(2, '0');
    return "$minutes:$remainder";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),

      body: Column(
        children: [
          // ===== LIST OF EXERCISES =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.exercises[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise["name"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Level: ${exercise["level"]!}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Recommended: ${exercise["reps"]!}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===== TIMER + SETS PANEL AT BOTTOM =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Column(
              children: [
                // SETS CONTROLS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, size: 32),
                      onPressed: () {
                        if (sets > 1) setState(() => sets--);
                      },
                    ),
                    Text(
                      "Sets: $sets",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 32),
                      onPressed: () {
                        setState(() => sets++);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // TIMER DISPLAY
                Text(
                  formatTime(seconds),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // TIMER BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: startTimer,
                      child: const Text("Start"),
                    ),
                    ElevatedButton(
                      onPressed: pauseTimer,
                      child: const Text("Pause"),
                    ),
                    ElevatedButton(
                      onPressed: resetTimer,
                      child: const Text("Reset"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
