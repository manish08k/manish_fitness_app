import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {

  String selectedPeriod = "Day";

  List<double> stepsData = [1200, 1500, 1800, 2000, 2500, 3000, 3200];
  List<double> caloriesData = [200, 250, 300, 280, 350, 400, 420];
  List<double> heartData = [80, 85, 78, 90, 88, 92, 86];

  void changePeriod(String period) {
    setState(() {
      selectedPeriod = period;

      if (period == "Day") {
        stepsData = [1200, 1500, 1800, 2000, 2500, 3000, 3200];
        caloriesData = [200, 250, 300, 280, 350, 400, 420];
        heartData = [80, 85, 78, 90, 88, 92, 86];
      } else if (period == "Week") {
        stepsData = [8000, 9000, 10000, 11000, 9500, 12000, 13000];
        caloriesData = [1800, 2000, 2100, 1900, 2200, 2500, 2600];
        heartData = [78, 82, 85, 80, 88, 90, 84];
      } else {
        stepsData = [30000, 40000, 35000, 42000, 45000, 47000, 50000];
        caloriesData = [7000, 7500, 8000, 8200, 8500, 9000, 9500];
        heartData = [75, 78, 80, 82, 84, 85, 87];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Analytics Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            buildToggle(),

            const SizedBox(height: 20),

            buildChartCard("Steps", stepsData, Colors.blue),

            const SizedBox(height: 20),

            buildBarChartCard("Calories", caloriesData, Colors.red),

            const SizedBox(height: 20),

            buildChartCard("Heart Rate", heartData, Colors.green),

          ],
        ),
      ),
    );
  }

  Widget buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ["Day", "Week", "Month"].map((e) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            selectedPeriod == e ? Colors.blue : Colors.grey.shade300,
            foregroundColor:
            selectedPeriod == e ? Colors.white : Colors.black,
          ),
          onPressed: () => changePeriod(e),
          child: Text(e),
        );
      }).toList(),
    );
  }

  Widget buildChartCard(String title, List<double> data, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: color,
                    barWidth: 4,
                    spots: data
                        .asMap()
                        .entries
                        .map((e) =>
                        FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBarChartCard(String title, List<double> data, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                barGroups: data
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: color,
                      width: 14,
                      borderRadius:
                      BorderRadius.circular(6),
                    )
                  ],
                ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
