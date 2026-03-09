import 'package:flutter/material.dart';

class GymNearbyPage extends StatelessWidget {
  const GymNearbyPage({super.key});

  final List<Map<String, String>> gyms = const [
    {
      "name": "Iron Beast Gym",
      "location": "2.1 km away",
      "rating": "4.8 ⭐"
    },
    {
      "name": "Power House Fitness",
      "location": "3.5 km away",
      "rating": "4.6 ⭐"
    },
    {
      "name": "Muscle Factory",
      "location": "1.2 km away",
      "rating": "4.9 ⭐"
    },
    {
      "name": "FitZone Club",
      "location": "4.0 km away",
      "rating": "4.5 ⭐"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gyms Nearby")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gyms.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: const Icon(Icons.fitness_center, size: 35),
              title: Text(
                gyms[index]["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "${gyms[index]["location"]} • ${gyms[index]["rating"]}"),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text("View"),
              ),
            ),
          );
        },
      ),
    );
  }
}
