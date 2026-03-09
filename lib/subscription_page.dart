import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Premium Subscription")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.workspace_premium,
                size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              "Unlock Premium Fitness Features",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text("Exclusive workouts, AI coach, diet plans"),
          ],
        ),
      ),
    );
  }
}
