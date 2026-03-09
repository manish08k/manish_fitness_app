import 'package:flutter/material.dart';

class HIITListPage extends StatelessWidget {
  final String title;

  const HIITListPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final exercises = hiitExercises[title] ?? ["No exercises found"];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade200,
            ),
            child: Text(
              exercises[index],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ✅ FULL DATA MAP (NO ERRORS)
final Map<String, List<String>> hiitExercises = {
  "Beginner Cardio": [
    "Marching in place",
    "Slow jogging",
    "Side steps",
    "Light jump rope",
    "Toe taps",
  ],

  "Fat Loss Cardio": [
    "Fast Jumping Jacks",
    "High Knees",
    "Bursts of running",
    "Quick step-ups",
    "Fast rope skipping",
  ],

  "Endurance Cardio": [
    "Jog 20 minutes",
    "Shadow boxing",
    "Long cycling",
    "Rowing endurance",
    "Extended stair climb",
  ],

  "Home Cardio": [
    "Butt Kicks",
    "Mountain Climbers",
    "Skaters",
    "Jump squats",
    "Lateral hops",
  ],

  "Outdoor Cardio": [
    "Sprinting",
    "Hill runs",
    "Walk-jog intervals",
    "Side shuffles",
  ],

  "Equipment Cardio": [
    "Treadmill sprints",
    "Cycling intervals",
    "Rowing machine bursts",
    "Battle ropes",
    "Kettlebell swings",
  ],
};
