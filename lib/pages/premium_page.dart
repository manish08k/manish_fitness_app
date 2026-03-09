import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Premium Membership")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium,
                size: 90, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              "Upgrade to Premium",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            buildFeature("Unlimited Workout Plans"),
            buildFeature("Advanced Analytics"),
            buildFeature("AI Personal Trainer"),
            buildFeature("Ad Free Experience"),
            buildFeature("Priority Support"),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15),
              ),
              onPressed: () {},
              child: const Text("Subscribe Now"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
