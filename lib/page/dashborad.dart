import 'package:esprit/page/parentSD.dart';
import 'package:esprit/page/stat.dart';
import 'package:esprit/page/statFinal.dart';
import 'package:flutter/material.dart';

import 'absence.dart';
import 'contactUs.dart';
import 'event.dart';
import 'motivation.dart';
import 'result.dart';
import 'settingG.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  final String studentId;

  DashboardPage({required this.studentId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentData;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService();
    studentData = apiService.studentStudyHours(widget.studentId); // Fetch the data using your API service
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                color: Color(0xFFF0F0F1),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important to allow content to shrink
                  children: [
                    SizedBox(height: height * 0.1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Row(
                        children: [
                          Text(
                            'Hi, Mr & Mrs',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            '${data['prenom']}',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/settingg.png',
                                  width: width * 0.07,
                                  height: width * 0.07,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              SizedBox(width: width * 0.05),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventPage(studentId: widget.studentId),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/calendar.png',
                                  width: width * 0.07,
                                  height: width * 0.07,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.3,
                      margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.05, width * 0.05, height * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: width * 0.03,
                            spreadRadius: 1,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Important to allow content to shrink
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Statistical',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatFinalPage(studentId: widget.studentId),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/seemore.png',
                                    width: width * 0.06,
                                    height: width * 0.06,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible( // To fit inside the column without causing an overflow
                            child: MotivationalMessageWidget(studentId: widget.studentId),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.2,
                      margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(width * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: width * 0.03,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/seemore.png',
                                          width: width * 0.06,
                                          height: width * 0.06,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: Text(
                                      '5655446',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      children: [
                                        Text(
                                          '#',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Text(
                                          'Valid',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(width * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: width * 0.03,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Contact',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FacultyContactPage(studentId: widget.studentId),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/seemore.png',
                                            width: width * 0.06,
                                            height: width * 0.06,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Expanded(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: width * 0.02,
                                          child: CircleAvatarWithShadow(
                                            initial: 'A',
                                            shadowColor: Colors.red.shade900,
                                            backgroundColor: Colors.red.shade700,
                                          ),
                                        ),
                                        Positioned(
                                          left: width * 0.13,
                                          child: CircleAvatarWithShadow(
                                            initial: 'C',
                                            shadowColor: Colors.red.shade900,
                                            backgroundColor: Colors.red.shade700,
                                          ),
                                        ),
                                        Positioned(
                                          left: width * 0.25,
                                          child: CircleAvatarWithShadow(
                                            initial: 'S',
                                            shadowColor: Colors.red.shade900,
                                            backgroundColor: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.2,
                      margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(width * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: width * 0.03,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Absence',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AbsencePage(studentId: widget.studentId),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/seemore.png',
                                            width: width * 0.06,
                                            height: width * 0.06,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: CircularProgressIndicatorWithText(
                                      percentage: double.tryParse(data['percentage_present']?.replaceAll('%', '')) ?? 0.0,
                                      displayText: '${data['percentage_present']}%',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Absence:',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${data['total_absences']}',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(width * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: width * 0.03,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.04),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Result',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ResultPage(studentId: widget.studentId),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/seemore.png',
                                            width: width * 0.06,
                                            height: width * 0.06,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'assets/img_2.png', // Keeping the original photo
                                        width: width * 0.35,
                                        height: width * 0.35,
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
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}

class CircleAvatarWithShadow extends StatelessWidget {
  final String initial;
  final Color shadowColor;
  final Color backgroundColor;

  const CircleAvatarWithShadow({
    Key? key,
    required this.initial,
    required this.shadowColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: 25,
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CircularProgressIndicatorWithText extends StatelessWidget {
  final double percentage;
  final String displayText;

  const CircularProgressIndicatorWithText({
    Key? key,
    required this.percentage,
    required this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percentage / 100.0,
            strokeWidth: 6,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade700),
          ),
          Center(
            child: Text(
              displayText,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
