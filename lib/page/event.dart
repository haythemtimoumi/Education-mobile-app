import 'package:esprit/page/weather/empoi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class EventPage extends StatefulWidget {
  final String studentId;

  EventPage({required this.studentId});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int? selectedDayIndex;
  late List<DateTime> weekDates;
  final ApiService apiService = ApiService();
  List<List<dynamic>> emploiData = [];
  bool isLoading = false;
  String? codeCl; // To store the fetched CODE_CL

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    _fetchCodeClAndEmploiData(); // Fetch CODE_CL and then emploi data
  }

  void _generateWeekDates() {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    weekDates = List.generate(5, (index) => firstDayOfWeek.add(Duration(days: index)));
    selectedDayIndex = 0;
  }

  // Method to fetch CODE_CL and then fetch emploi data
  Future<void> _fetchCodeClAndEmploiData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch CODE_CL using the student's ID
      codeCl = await apiService.fetchCodeClByStudentId(widget.studentId);

      // Once CODE_CL is fetched, fetch emploi data for the selected day
      _fetchEmploiDataForSelectedDay();
    } catch (e) {
      print('Error fetching CODE_CL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load class code (CODE_CL)')),
      );
    }
  }

  // Fetch emploi data for the selected day using CODE_CL
  void _fetchEmploiDataForSelectedDay() async {
    if (selectedDayIndex == null || codeCl == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      String date = DateFormat('yyyy-MM-dd').format(weekDates[selectedDayIndex!]);
      List<List<dynamic>> data = await apiService.fetchEmploiByClasseAndDate(codeCl!, date: date); // Use fetched CODE_CL

      setState(() {
        emploiData = data;
      });
    } catch (e) {
      print('Error fetching emploi data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load emploi data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth - 35;
    double itemWidth = (containerWidth - 6 * 12) / 5;
    double itemHeight = itemWidth * 1.2;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(screenWidth * 0.05),
                        bottomRight: Radius.circular(screenWidth * 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.015,
                    left: screenWidth * 0.025,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/sort.png',
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : emploiData.isEmpty
                      ? Center(child: Text('No data available for this day'))
                      : ListView.builder(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    itemCount: emploiData.length,
                    itemBuilder: (context, index) {
                      final item = emploiData[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: screenWidth * 0.05),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Module: ${item[5]}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Enseignant: ${item[1]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Time: ${item[6]} - ${item[7]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.10,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Container(
              width: containerWidth,
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'This Week\'s Timetable',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EmploiPage(className: codeCl ?? 'Unknown'), // Use dynamic codeCl
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/umbrella.png',
                          width: screenWidth * 0.06,
                          height: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  SizedBox(
                    height: itemHeight + screenHeight * 0.02,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < weekDates.length; i++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDayIndex = i;
                                });
                                _fetchEmploiDataForSelectedDay();
                              },
                              child: Container(
                                width: itemWidth,
                                height: itemHeight,
                                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                decoration: BoxDecoration(
                                  color: selectedDayIndex == i ? Colors.red.shade700 : Colors.white,
                                  borderRadius: BorderRadius.circular(screenWidth * 0.045),
                                  border: Border.all(
                                    color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                    width: 2.0,
                                  ),
                                  boxShadow: selectedDayIndex == i
                                      ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.7),
                                      offset: Offset(0, 9),
                                      blurRadius: 6,
                                    ),
                                  ]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('E').format(weekDates[i]),
                                      style: TextStyle(
                                        color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      DateFormat('dd').format(weekDates[i]),
                                      style: TextStyle(
                                        color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
