import 'package:flutter/material.dart';
import 'screen_ai/exercise_screen.dart';
import 'screen_ai/cardio_data.dart';


class CardioPage extends StatelessWidget {
  const CardioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cardio Workouts")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildCardioButton(
              context,
              "Beginner Cardio",
              Icons.directions_walk,
              beginnerCardio,
            ),
            buildCardioButton(
              context,
              "Fat Loss Cardio",
              Icons.local_fire_department,
              fatLossCardio,
            ),
            buildCardioButton(
              context,
              "Endurance Cardio",
              Icons.bolt,
              enduranceCardio,
            ),
            buildCardioButton(
              context,
              "Home Cardio",
              Icons.home,
              homeCardio,
            ),
            buildCardioButton(
              context,
              "Outdoor Cardio",
              Icons.park,
              outdoorCardio,
            ),
            buildCardioButton(
              context,
              "Equipment Cardio",
              Icons.fitness_center,
              equipmentCardio,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardioButton(
      BuildContext context,
      String title,
      IconData icon,
      List<Map<String, String>> exerciseList,
      ) {
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
                exercises: exerciseList,
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
