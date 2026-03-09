import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final user = FirebaseAuth.instance.currentUser;

  int height = 170;
  int weight = 72;
  int age = 21;
  String goal = "Muscle Gain";

  Map<DateTime, int> activityData = {};
  DateTime selectedMonth = DateTime.now();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadProfile() async {
    try {
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        height = data["height"] ?? 170;
        weight = data["currentWeight"] ?? 72;
        age = data["age"] ?? 21;
        goal = data["goal"] ?? "Muscle Gain";
      }

      await _loadActivity();

    } catch (e) {
      print("Profile load error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ================= LOAD ACTIVITY =================
  Future<void> _loadActivity() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("activity")
        .get();

    Map<DateTime, int> temp = {};

    for (var doc in snapshot.docs) {
      try {
        DateTime date = DateTime.parse(doc.id);
        temp[DateTime(date.year, date.month, date.day)] = 1;
      } catch (_) {}
    }

    activityData = temp;
  }

  // ================= SAFE UPDATE =================
  Future<void> _updateField(String key, dynamic value) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({key: value}, SetOptions(merge: true));

    if (mounted) {
      setState(() {
        if (key == "height") height = value;
        if (key == "currentWeight") weight = value;
        if (key == "age") age = value;
        if (key == "goal") goal = value;
      });
    }
  }

  // ================= MARK TODAY DONE =================
  Future<void> _markTodayDone() async {
    if (user == null) return;

    DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("activity")
        .doc(today.toIso8601String())
        .set({"done": true});

    if (mounted) {
      setState(() {
        activityData[today] = 1;
      });
    }
  }

  // ================= EDIT INT FIELD =================
  Future<void> _editIntField(String label, int value, String key) async {
    final controller = TextEditingController(text: value.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text("Edit $label"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final newValue =
              int.tryParse(controller.text.trim());
              if (newValue != null) {
                await _updateField(key, newValue);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // ================= EDIT STRING FIELD =================
  Future<void> _editStringField(String label, String value, String key) async {
    final controller = TextEditingController(text: value);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text("Edit $label"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                await _updateField(key, newValue);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Widget _cardTile(String title, String value, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value),
            const SizedBox(width: 8),
            const Icon(Icons.edit, size: 18),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue.shade200,
              child: const Icon(Icons.person,
                  size: 80, color: Colors.white),
            ),

            const SizedBox(height: 25),

            _cardTile("Height (cm)", "$height",
                    () => _editIntField("Height", height, "height")),
            _cardTile("Weight (kg)", "$weight",
                    () => _editIntField("Weight", weight, "currentWeight")),
            _cardTile("Age", "$age",
                    () => _editIntField("Age", age, "age")),
            _cardTile("Goal", goal,
                    () => _editStringField("Goal", goal, "goal")),

            const SizedBox(height: 25),

            HeatMap(
              startDate: DateTime(selectedMonth.year,
                  selectedMonth.month, 1),
              endDate: DateTime(selectedMonth.year,
                  selectedMonth.month + 1, 0),
              datasets: activityData,
              colorMode: ColorMode.color,
              defaultColor: Colors.grey.shade300,
              textColor: Colors.black,
              colorsets: const {1: Colors.green},
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: _markTodayDone,
              icon: const Icon(Icons.check),
              label: const Text("Mark Today Completed"),
            ),
          ],
        ),
      ),
    );
  }
}
