import 'package:esprit/page/student_stats_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../services/api_service.dart';
import '../stats/radar_chart_widget.dart';
import 'charts/barchartM.dart';
import 'charts/linechart.dart';
import 'charts/radarchart.dart';

class StatPage extends StatefulWidget {
  final String studentId;

  StatPage({required this.studentId});

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  String selectedModuleName = '';
  Map<String, double> chartData = {};
  List<String> moduleNamesWithIndex = [];  // This will hold LIB_UE with a unique index
  bool isLoading = true;
  double totalHours = 0;
  int absenceCount = 0;
  List<RadarData> radarData = []; // To hold radar chart data
  List<List<dynamic>> modules = [];  // To hold the full data response from API

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  // Fetch modules and subject names (LIB_UE)
  void fetchModules() async {
    try {
      ApiService apiService = ApiService();
      modules = await apiService.fetchStudentModulesSt(widget.studentId);

      setState(() {
        // Extract subject names (LIB_UE) for the dropdown, and add an index to avoid duplicates
        moduleNamesWithIndex = List.generate(modules.length, (index) => '${modules[index][9]}_$index');
        selectedModuleName = moduleNamesWithIndex.isNotEmpty ? moduleNamesWithIndex[0] : '';  // Set default selection
        isLoading = false;
      });

      fetchChartData();
    } catch (e) {
      print('Error fetching modules: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch chart data based on the selected subject (LIB_UE)
  void fetchChartData() async {
    if (selectedModuleName.isEmpty) return;

    try {
      // Extract the original subject name (LIB_UE) by removing the added index
      String originalModuleName = selectedModuleName.split('_')[0];

      // Find the selected module data based on LIB_UE (subject name)
      List<dynamic> selectedModuleData = modules.firstWhere((module) => module[9] == originalModuleName);  // LIB_UE at index 9

      setState(() {
        totalHours = double.parse(selectedModuleData[4].toString());  // NB_HEURES at index 4
        absenceCount = int.parse(selectedModuleData[8].toString());  // Absence count at index 8
      });

      double absentHours = absenceCount * 1.5;
      double presentHours = totalHours - absentHours;

      double presentPercentage = (presentHours / totalHours) * 100;
      double absentPercentage = (absentHours / totalHours) * 100;

      setState(() {
        chartData = {
          "Present": presentPercentage,
          "Absent": absentPercentage,
        };

        // Prepare data for radar chart
        radarData = modules.map((module) {
          final subjectName = module[9].toString();  // LIB_UE at index 9
          final moduleTotalHours = double.parse(module[4].toString());  // NB_HEURES at index 4
          final moduleAbsenceCount = int.parse(module[8].toString());  // Absence count at index 8
          final moduleAbsentHours = moduleAbsenceCount * 1.5;
          final moduleRequiredHours = moduleTotalHours - moduleAbsentHours;
          return RadarData(
            moduleName: subjectName,  // Use LIB_UE (subject name)
            value: moduleRequiredHours,
          );
        }).toList();
      });
    } catch (e) {
      print('Error calculating chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Statistical',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto', // Replace with your preferred font
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Adjust the padding if needed
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when the icon is tapped
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

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: DropdownButton<String>(
                      value: selectedModuleName,  // Use LIB_UE with index as the value
                      dropdownColor: Colors.redAccent,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      iconEnabledColor: Colors.white,
                      items: moduleNamesWithIndex.map((nameWithIndex) {
                        return DropdownMenuItem(
                          value: nameWithIndex,
                          // Show only the original LIB_UE (subject name) in the dropdown
                          child: Text(
                            nameWithIndex.split('_')[0],  // Split to display LIB_UE without the index
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedModuleName = value!;
                          fetchChartData();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  chartData.isNotEmpty
                      ? PieChart(
                    dataMap: chartData,
                    chartType: ChartType.ring,
                    colorList: [Colors.green.shade400, Colors.red.shade400],
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    animationDuration: Duration(milliseconds: 1500),
                    chartLegendSpacing: 40,
                    centerText: "Attendance",
                    centerTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.bottom,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: true,
                      chartValueStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ringStrokeWidth: 30,
                  )
                      : Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Hours: ${totalHours.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Number of Absences: $absenceCount',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: RadarChartWidget(
                data: radarData,
                title: 'Power and Weakness',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

