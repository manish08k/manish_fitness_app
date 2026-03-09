import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, String> events = {};

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    events = Map<String, String>.from(
        prefs.getStringList("calendar_events")?.asMap().map(
              (key, value) => MapEntry(value.split("|")[0], value.split("|")[1]),
        ) ??
            {});
    setState(() {});
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final list = events.entries
        .map((e) => "${e.key}|${e.value}")
        .toList();
    await prefs.setStringList("calendar_events", list);
  }

  void _addEvent() {
    if (_selectedDay == null || _controller.text.isEmpty) return;

    String key = _selectedDay!.toIso8601String();
    events[key] = _controller.text;

    _saveEvents();
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? eventText =
    events[_selectedDay?.toIso8601String() ?? ""];

    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),

          const SizedBox(height: 10),

          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Assign event for this date"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addEvent,
                    child: const Text("Save Event"),
                  ),
                  const SizedBox(height: 10),
                  if (eventText != null)
                    Text(
                      "Event: $eventText",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    )
                ],
              ),
            )
        ],
      ),
    );
  }
}
