import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/module_performance.dart';
import '../services/api_service.dart';

class StudentStatsChart extends StatefulWidget {
  final String studentId;

  const StudentStatsChart({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentStatsChartState createState() => _StudentStatsChartState();
}

class _StudentStatsChartState extends State<StudentStatsChart> {
  late Future<List<ModulePerformance>> _studentStats;
  String selectedTypeMoyenne = 'P'; // Default to 'P'

  @override
  void initState() {
    super.initState();
    _studentStats = ApiService().fetchStudentStats(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft grey background
      appBar: AppBar(
        title: const Text(
          'Student Stats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87, // Neutral text color
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent app bar for a clean look
        elevation: 0, // Remove shadow
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87), // Modern icon color
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: ToggleButtons(
              isSelected: [selectedTypeMoyenne == 'P', selectedTypeMoyenne == 'R'],
              onPressed: (index) {
                setState(() {
                  selectedTypeMoyenne = index == 0 ? 'P' : 'R';
                });
              },
              borderRadius: BorderRadius.circular(30), // More rounded for a modern touch
              selectedColor: Colors.white,
              fillColor: Colors.red.shade700, // Modern red for the fill
              color: Colors.grey.shade600, // Softer color when not selected
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.06,
                minWidth: MediaQuery.of(context).size.width * 0.35,
              ),
              children: const [
                Text('P', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('R', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Legend Row with SingleChildScrollView
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: SingleChildScrollView( // Add this to allow horizontal scrolling
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Colors.red.shade700, "Student Moyenne"),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  _buildLegendItem(Colors.blue.shade700, "Class Average Moyenne"),
                ],
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<ModulePerformance>>(
              future: _studentStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No stats found for this student.'));
                } else {
                  final stats = snapshot.data!
                      .where((stat) => stat.typeMoyenne == selectedTypeMoyenne)
                      .toList();
                  return _buildChart(stats);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.04,
          height: MediaQuery.of(context).size.width * 0.04,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12), // More rounded for a modern feel
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Softer shadow
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w500, // Softer weight
            color: Colors.grey.shade700, // Softer text color
          ),
        ),
      ],
    );
  }

  Widget _buildChart(List<ModulePerformance> data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: BarChart(
        BarChartData(
          maxY: data.map((e) => e.classAverageMoyenne).reduce((a, b) => a > b ? a : b) + 5,
          barGroups: data.map((stat) {
            return BarChartGroupData(
              x: data.indexOf(stat),
              barsSpace: MediaQuery.of(context).size.width * 0.03, // More space between bars
              barRods: [
                BarChartRodData(
                  toY: stat.studentMoyenne,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade300], // Softer gradient
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: MediaQuery.of(context).size.width * 0.045, // Slightly thinner bars
                  borderRadius: BorderRadius.circular(8), // Rounded corners for modern look
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      stat.studentMoyenne,
                      Colors.red.shade600,
                    ),
                  ],
                ),
                BarChartRodData(
                  toY: stat.classAverageMoyenne,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade300],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: MediaQuery.of(context).size.width * 0.045,
                  borderRadius: BorderRadius.circular(8),
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      stat.classAverageMoyenne,
                      Colors.blue.shade600,
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: MediaQuery.of(context).size.height * 0.05,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      data[value.toInt()].module,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w500, // Softer font weight
                        color: Colors.grey.shade800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String moduleName = data[group.x].module;
                String value = rod.toY.toStringAsFixed(2);
                return BarTooltipItem(
                  '$moduleName\n$value',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Slightly smaller for a modern look
                  ),
                );
              },
            ),
            allowTouchBarBackDraw: true,
          ),
        ),
      ),
    );
  }
}
