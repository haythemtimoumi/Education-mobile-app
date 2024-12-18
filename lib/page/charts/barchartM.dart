import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:esprit/services/api_service.dart';

class BarChartSample1 extends StatefulWidget {
  final String studentId;
  final String studentClass;

  BarChartSample1({required this.studentId, required this.studentClass});

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? studyProgress;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudyProgress();
  }

  Future<void> fetchStudyProgress() async {
    try {
      final data = await apiService.fetchStudyProgress(widget.studentId, widget.studentClass);
      setState(() {
        studyProgress = data['days'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double availableWidth = constraints.maxWidth;
            double availableHeight = constraints.maxHeight;

            double titleFontSize = availableWidth * 0.06;
            double subtitleFontSize = availableWidth * 0.04;
            double legendFontSize = availableWidth * 0.04;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context, titleFontSize, subtitleFontSize),
                  SizedBox(height: availableHeight * 0.02),
                  _buildLegend(legendFontSize),
                  SizedBox(height: availableHeight * 0.05),
                  _buildAxisLabels(context, screenWidth, screenHeight),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade50,
                          Colors.red.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: availableHeight * 0.6,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : errorMessage != null
                          ? Center(child: Text('Error: $errorMessage'))
                          : BarChart(mainBarData(constraints, screenWidth, screenHeight)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double titleFontSize, double subtitleFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.red.shade700),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Overview',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daily Scheduled vs. Attended Hours',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Adjust if needed, ensures no overflow
        ],
      ),
    );
  }

  Widget _buildLegend(double legendFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(Colors.grey.shade300, 'Total hours', legendFontSize),
          SizedBox(width: 20),
          _buildLegendItem(Colors.red.shade700, 'Present hours', legendFontSize),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, double fontSize) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAxisLabels(BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "X-Axis: Subjects",
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Y-Axis: Attendance Hours",
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double totalHours,
      double presentHours, {
        bool isTouched = false,
        double width = 22,
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: totalHours.toDouble(), // Ensure it's double
          color: Colors.grey.shade300,
          width: width,
          borderRadius: BorderRadius.circular(12),
        ),
        BarChartRodData(
          toY: isTouched ? presentHours.toDouble() + 0.5 : presentHours.toDouble(), // Ensure it's double
          color: isTouched ? Colors.orangeAccent : Colors.red.shade700,
          width: width - 6,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    if (studyProgress == null) return [];

    return [
      makeGroupData(
        0,
        (studyProgress?['Monday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Monday']?['remaining_hours'] ?? 0).toDouble(),
      ),
      makeGroupData(
        1,
        (studyProgress?['Tuesday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Tuesday']?['remaining_hours'] ?? 0).toDouble(),
      ),
      makeGroupData(
        2,
        (studyProgress?['Wednesday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Wednesday']?['remaining_hours'] ?? 0).toDouble(),
      ),
      makeGroupData(
        3,
        (studyProgress?['Thursday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Thursday']?['remaining_hours'] ?? 0).toDouble(),
      ),
      makeGroupData(
        4,
        (studyProgress?['Friday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Friday']?['remaining_hours'] ?? 0).toDouble(),
      ),
      makeGroupData(
        5,
        (studyProgress?['Saturday']?['scheduled_hours'] ?? 0).toDouble(),
        (studyProgress?['Saturday']?['remaining_hours'] ?? 0).toDouble(),
      ),
    ];
  }

  BarChartData mainBarData(BoxConstraints constraints, double screenWidth, double screenHeight) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              default:
                throw Error();
            }

            String label = rod.color == Colors.grey.shade300 ? 'Total: ' : 'Present: ';
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: '$label${rod.toY} hrs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12);
              switch (value.toInt()) {
                case 0:
                  return Text('M', style: style);
                case 1:
                  return Text('T', style: style);
                case 2:
                  return Text('W', style: style);
                case 3:
                  return Text('T', style: style);
                case 4:
                  return Text('F', style: style);
                case 5:
                  return Text('S', style: style);
                default:
                  return const Text('');
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 12);
              return Text('${value.toInt()}', style: style);
            },
            reservedSize: 40, // Increased from 28 to 40 for better alignment
          ),
        ),
        rightTitles: AxisTitles( // Optional, add this if you need alignment for the right side
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 12);
              return Text('${value.toInt()}', style: style);
            },
            reservedSize: 40, // Ensure both sides have enough space for the labels
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.shade300,
          strokeWidth: 1,
        ),
      ),
    );
  }

}
