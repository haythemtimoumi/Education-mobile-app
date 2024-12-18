import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../model/module_performance.dart';
import '../../services/api_service.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.isShowingMainData,
    required this.performanceDataP,
    required this.performanceDataR,
  });

  final bool isShowingMainData;
  final List<ModulePerformance> performanceDataP;
  final List<ModulePerformance> performanceDataR;

  @override
  Widget build(BuildContext context) {
    final List<ModulePerformance> data = isShowingMainData ? performanceDataP : performanceDataR;
    double screenWidth = MediaQuery.of(context).size.width;

    // Display a message if no data is available
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.black87),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: data.length * (screenWidth / 5),
            child: LineChart(
              sampleDataFromApi(data, context),
              duration: const Duration(milliseconds: 250),
            ),
          ),
        );
      },
    );
  }

  LineChartData sampleDataFromApi(List<ModulePerformance> data, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return LineChartData(
      lineBarsData: [
        // Student performance line
        LineChartBarData(
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.red.shade700, Colors.red.shade200]),
          barWidth: screenHeight * 0.005,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.red.shade700.withOpacity(0.3), Colors.red.shade700.withOpacity(0.0)],
            ),
          ),
          spots: data.asMap().entries.map((entry) {
            int index = entry.key;
            ModulePerformance module = entry.value;
            return FlSpot(index.toDouble(), module.studentMoyenne ?? 0.0);
          }).toList(),
        ),
        // Class average line
        LineChartBarData(
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade100]),
          barWidth: screenHeight * 0.004,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: data.asMap().entries.map((entry) {
            int index = entry.key;
            ModulePerformance module = entry.value;
            return FlSpot(index.toDouble(), module.classAverageMoyenne ?? 0.0);
          }).toList(),
        ),
      ],
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: 20,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: screenHeight * 0.05,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < data.length) {
                String shortLabel = data[index].ueName.substring(0, 3);  // Use LIB_UE here
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Text('Full Subject Name'),
                          content: Text(data[index].ueName),  // Show full LIB_UE on tap
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: screenHeight * 0.01,
                    child: Text(
                      shortLabel,
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: screenHeight * 0.05,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.end,
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipRoundedRadius: 8,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(1)}\n',
                TextStyle(
                  color: spot.bar.gradient?.colors[0] ?? Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: screenHeight * 0.0015),
      ),
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  final String studentId;

  const LineChartSample1({super.key, required this.studentId});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  List<ModulePerformance> performanceDataP = [];
  List<ModulePerformance> performanceDataR = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    _fetchPerformanceData();
  }

  Future<void> _fetchPerformanceData() async {
    ApiService apiService = ApiService();
    try {
      List<ModulePerformance> data = await apiService.fetchStudentStats(widget.studentId);
      setState(() {
        performanceDataP = data.where((module) => module.typeMoyenne == 'P').toList();
        performanceDataR = data.where((module) => module.typeMoyenne == 'R').toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Performance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenHeight * 0.03,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Principal',
                        style: TextStyle(fontSize: screenHeight * 0.02, color: Colors.black87),
                      ),
                      Switch(
                        value: !isShowingMainData,
                        onChanged: (value) {
                          setState(() {
                            isShowingMainData = !value;
                          });
                        },
                        activeColor: Colors.red.shade700,
                      ),
                      Text(
                        'Rattrapage',
                        style: TextStyle(fontSize: screenHeight * 0.02, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: screenHeight * 0.015,
                            height: screenHeight * 0.015,
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Student Note',
                            style: TextStyle(fontSize: screenHeight * 0.015),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Row(
                        children: [
                          Container(
                            width: screenHeight * 0.015,
                            height: screenHeight * 0.015,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Average Note',
                            style: TextStyle(fontSize: screenHeight * 0.015),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.04, left: screenWidth * 0.02),
                      child: _LineChart(
                        isShowingMainData: isShowingMainData,
                        performanceDataP: performanceDataP,
                        performanceDataR: performanceDataR,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
