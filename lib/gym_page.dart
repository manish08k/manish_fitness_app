import 'package:flutter/material.dart';
import 'screen_ai/exercise_screen.dart';
import 'data/chest_data.dart';
import 'data/back_data.dart';
import 'data/shoulders_data.dart';
import 'data/legs_data.dart';
import 'data/core_data.dart';
import 'data/bicep_data.dart';
import 'data/tricep_data.dart';


class GymPage extends StatelessWidget {
  const GymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gym Workouts")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGymButton(context, "Chest", Icons.favorite),
            buildGymButton(context, "Back", Icons.autorenew),
            buildGymButton(context, "Shoulders", Icons.accessibility_new),
            buildGymButton(context, "Legs", Icons.directions_walk),
            buildGymButton(context, "Core", Icons.shield),
            buildGymButton(context, "Bicep", Icons.fitness_center),
            buildGymButton(context, "Tricep", Icons.flash_on),
          ],
        ),
      ),
    );
  }

  Widget buildGymButton(BuildContext context, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseScreen(
                title: title,
                exercises: getExerciseList(title),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 38),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> getExerciseList(String title) {
    switch (title) {
      case "Chest":
        return chestExercises;
      case "Back":
        return backExercises;
      case "Shoulders":
        return shoulderExercises;
      case "Legs":
        return legExercises;
      case "Core":
        return coreExercises;
      case "Bicep":
        return bicepExercises;
      case "Tricep":
        return tricepExercises;
      default:
        return [];
    }
  }
}
