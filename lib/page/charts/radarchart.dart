import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../model/module.dart';
import '../../services/api_service.dart';

class RadarChartExample extends StatefulWidget {
  final String studentId;

  RadarChartExample({required this.studentId});

  @override
  _RadarChartExampleState createState() => _RadarChartExampleState();
}

class _RadarChartExampleState extends State<RadarChartExample> with SingleTickerProviderStateMixin {
  bool isPrincipalMode = true;  // Default to Principal results
  late Future<List<StudentModule>> modulesP;
  late Future<List<StudentModule>> modulesR;
  late AnimationController _controller;
  bool isDialogOpen = false;  // Prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),  // Animation duration
    )..forward();  // Start animation

    // Fetch data from ApiService with caching (already handled by your ApiService)
    modulesP = ApiService().fetchStudentModules(widget.studentId);  // Principal data
    modulesR = ApiService().fetchStudentModulesR(widget.studentId);  // Makeup data
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to show full subject name in a dialog (with dialog tracking)
  void showFullSubjectName(BuildContext context, String subjectName) {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Full Subject Name'),
            content: Text(subjectName),  // This is where the full name will be displayed
            actions: [
              TextButton(
                child: Text('Close', style: TextStyle(color: Colors.red.shade700)),
                onPressed: () {
                  isDialogOpen = false;  // Reset the dialog flag
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((_) {
        isDialogOpen = false;  // Ensure dialog flag is reset even if dialog is dismissed externally
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Simple white background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% horizontal padding
            vertical: screenHeight * 0.03, // 3% vertical padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row with Back Icon and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Back button to go to the previous screen
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.red.shade700, size: screenWidth * 0.07), // Responsive size
                    onPressed: () {
                      Navigator.pop(context);  // Navigate back
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Performance Overview',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: screenWidth * 0.06,  // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02), // 2% vertical space
              // Description
              Text(
                'Strengths and Weaknesses',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenWidth * 0.045,  // Responsive font size
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03), // 3% vertical space
              // Switcher between Principal and Makeup results
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Principal',
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
                  ),
                  Switch(
                    activeColor: Colors.red.shade700,
                    inactiveThumbColor: Colors.red.shade700,
                    value: isPrincipalMode,
                    onChanged: (value) {
                      setState(() {
                        isPrincipalMode = value;
                        _controller.reset();
                        _controller.forward();  // Animate on mode switch
                      });
                    },
                  ),
                  Text(
                    'Makeup',
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04), // 4% vertical space
              // Radar chart with overlays for tapping on the labels
              Expanded(
                child: FutureBuilder<List<StudentModule>>(
                  future: isPrincipalMode ? modulesP : modulesR,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red.shade700,
                          strokeWidth: 3,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading data',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<StudentModule> modules = snapshot.data!;

                      return Stack(
                        children: [
                          // Radar chart
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.05), // 5% padding inside card
                              child: RadarChart(
                                RadarChartData(
                                  radarTouchData: RadarTouchData(enabled: false),  // Disable touch events for data points
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: modules.map((module) {
                                        return RadarEntry(
                                          value: module.moyenneUE * _controller.value, // Show the notes
                                        );
                                      }).toList(),
                                      borderColor: Colors.red.shade700,
                                      fillColor: Colors.red.shade700.withOpacity(0.3),
                                      borderWidth: 2,
                                    ),
                                  ],
                                  radarBackgroundColor: Colors.transparent,
                                  borderData: FlBorderData(show: false),
                                  radarBorderData: BorderSide(color: Colors.grey.shade300, width: 2),
                                  tickBorderData: BorderSide(color: Colors.grey.shade300),
                                  gridBorderData: BorderSide(color: Colors.grey.shade200),
                                  titlePositionPercentageOffset: 0.1,
                                  titleTextStyle: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey.shade800),
                                  getTitle: (int index, double angle) {
                                    // Extracting short and full title from the API response
                                    String shortTitle = modules[index].libUE.length >= 3
                                        ? modules[index].libUE.substring(0, 3)
                                        : modules[index].libUE;

                                    return RadarChartTitle(
                                      text: shortTitle,
                                      angle: angle,
                                    );
                                  },
                                  ticksTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: screenWidth * 0.03),
                                  tickCount: 5,
                                ),
                              ),
                            ),
                          ),
                          // Dynamically create GestureDetector for each subject
                          for (int i = 0; i < modules.length; i++)
                            Positioned(
                              left: (i + 1) * 70.0, // Adjust the left position to match the radar chart label positions
                              top: (i + 1) * 50.0,  // Adjust the top position
                              child: GestureDetector(
                                onTap: () {
                                  showFullSubjectName(context, modules[i].libUE); // Show full name dynamically
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.transparent, // Invisible box for tap detection
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
