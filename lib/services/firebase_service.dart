import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get uid => _auth.currentUser!.uid;

  // ==============================
  // 🔹 BASIC PROFILE UPDATE
  // ==============================

  Future<void> updateProfile({
    required String name,
    required int age,
    required int height,
    required String goal,
    required int goalSteps,
    required int goalCalories,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "name": name,
      "age": age,
      "height": height,
      "goal": goal,
      "goalSteps": goalSteps,
      "goalCalories": goalCalories,
    }, SetOptions(merge: true));
  }

  // ==============================
  // 🔹 UPDATE TODAY STATS (MAIN ENGINE)
  // ==============================

  Future<void> updateTodayStats({
    int? steps,
    int? calories,
    double? weight,
    int? water,
    double? sleep,
  }) async {
    final now = DateTime.now();
    final docId =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("dailyStats")
        .doc(docId)
        .set({
      if (steps != null) "steps": steps,
      if (calories != null) "calories": calories,
      if (weight != null) "weight": weight,
      if (water != null) "water": water,
      if (sleep != null) "sleep": sleep,
      "date": now,
    }, SetOptions(merge: true));

    // Update latest weight in root
    if (weight != null) {
      await _firestore.collection("users").doc(uid).set({
        "currentWeight": weight,
      }, SetOptions(merge: true));
    }
  }

  // ==============================
  // 🔹 GET DAILY STATS (FOR GRAPHS)
  // ==============================

  Future<QuerySnapshot> getDailyStats() async {
    return await _firestore
        .collection("users")
        .doc(uid)
        .collection("dailyStats")
        .orderBy("date")
        .get();
  }

  // ==============================
  // 🔹 BADGE SYSTEM
  // ==============================

  Future<void> unlockBadge(String badgeId) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("badges")
        .doc(badgeId)
        .set({
      "unlockedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> getBadges() async {
    return await _firestore
        .collection("users")
        .doc(uid)
        .collection("badges")
        .get();
  }

  // ==============================
  // 🔹 WEEKLY TOTAL CALCULATOR
  // ==============================

  Future<Map<String, dynamic>> getWeeklyTotals() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final snapshot = await _firestore
        .collection("users")
        .doc(uid)
        .collection("dailyStats")
        .where("date", isGreaterThanOrEqualTo: weekAgo)
        .get();

    int totalSteps = 0;
    int totalCalories = 0;

    for (var doc in snapshot.docs) {
      totalSteps += (doc["steps"] ?? 0) as int;
      totalCalories += (doc["calories"] ?? 0) as int;
    }

    return {
      "steps": totalSteps,
      "calories": totalCalories,
    };
  }

  // ==============================
  // 🔹 MONTHLY TOTAL CALCULATOR
  // ==============================

  Future<Map<String, dynamic>> getMonthlyTotals() async {
    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month - 1, now.day);

    final snapshot = await _firestore
        .collection("users")
        .doc(uid)
        .collection("dailyStats")
        .where("date", isGreaterThanOrEqualTo: monthAgo)
        .get();

    int totalSteps = 0;
    int totalCalories = 0;

    for (var doc in snapshot.docs) {
      totalSteps += (doc["steps"] ?? 0) as int;
      totalCalories += (doc["calories"] ?? 0) as int;
    }

    return {
      "steps": totalSteps,
      "calories": totalCalories,
    };
  }
}
