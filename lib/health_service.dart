import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();

  /// Request permission from Health Connect
  Future<bool> requestPermission() async {
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
      ];

      bool requested = await _health.requestAuthorization(
        types,
        permissions: [
          HealthDataAccess.READ,
          HealthDataAccess.READ,
        ],
      );

      return requested;
    } catch (e) {
      print("Health Permission Error: $e");
      return false;
    }
  }

  /// Fetch last 24 hours health data
  Future<List<HealthDataPoint>> getData() async {
    try {
      DateTime now = DateTime.now();
      DateTime yesterday = now.subtract(const Duration(days: 1));

      List<HealthDataPoint> healthData =
      await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [
          HealthDataType.STEPS,
          HealthDataType.HEART_RATE,
        ],
      );

      // Remove duplicates
      return _health.removeDuplicates(healthData);
    } catch (e) {
      print("Health Data Error: $e");
      return [];
    }
  }

  /// Optional: Check if permissions already granted
  Future<bool> hasPermission() async {
    try {
      return await _health.hasPermissions([
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
      ]) ??
          false;
    } catch (e) {
      print("Permission Check Error: $e");
      return false;
    }
  }
}