import 'package:esprit/page/pdfStage.dart';
import 'package:esprit/page/reclamation.dart';
import 'package:esprit/page/stagemain.dart';
import 'package:flutter/material.dart';
import 'absence.dart';
import 'certifCrd.dart';
import 'charts/radarchart.dart';
import 'chatbot.dart';
import 'contact.dart';
import 'contactUs.dart';
import 'event.dart';
import 'internshipSubmission.dart';
import 'jstage.dart';
import 'login.dart';
import 'maps/mapFac.dart';
import 'profile.dart';
import 'result.dart';
import 'statFinal.dart';
import 'credit.dart';
import 'settingG.dart';
import 'teacher.dart';

class DashboardTT extends StatefulWidget {
  final String studentId;
  final String studentName;

  DashboardTT({required this.studentId, required this.studentName});

  @override
  _DashboardTTState createState() => _DashboardTTState();
}

class _DashboardTTState extends State<DashboardTT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, screenHeight * 0.005),
                      blurRadius: screenHeight * 0.008,
                    ),
                  ],
                ),
                height: screenHeight * 0.32,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Row(
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.09,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Flexible(
                        child: Text(
                          widget.studentName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.09,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle long names
                        ),
                      ),
                      Spacer(),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        child: Image.asset(
                          'assets/student.png',
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.all(screenWidth * 0.1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: screenWidth * 0.03,
                    mainAxisSpacing: screenWidth * 0.03,
                  ),
                  children: [
                    _buildGridItem(context, 'Absence', AssetImage('assets/absence.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AbsencePage(studentId: widget.studentId),
                           // builder: (context) => RadarChartExample(studentId: widget.studentId),

                        ),
                      );
                    }),
                    _buildGridItem(context, 'Resultat', AssetImage('assets/resultat.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(studentId: widget.studentId),
                        ),
                      );
                    }),
                    _buildGridItem(context, 'Timetable', AssetImage('assets/timetable.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPage(studentId: widget.studentId),
                        ),
                      );
                    }),
                    _buildGridItem(context, 'Map', AssetImage('assets/map.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(),
                        ),
                      );
                    }),
                    _buildGridItem(context, 'Statistical', AssetImage('assets/stats.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                         builder: (context) => StatFinalPage(studentId: widget.studentId),
                           // builder: (context) => RadarChartExample(),
                           // builder: (context) => ReclamationForm(studentId: widget.studentId),


                        ),
                      );
                    }),
                    _buildGridItem(context, 'Certif', AssetImage('assets/certificate.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditPage(studentId: widget.studentId),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              color: Colors.red.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Image.asset('assets/menu.png', width: screenWidth * 0.06, height: screenWidth * 0.06, color: Colors.white),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.25,
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, screenHeight * 0.005),
                    blurRadius: screenHeight * 0.008,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pack :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CHAT BOT :",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chatbot(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/chatbot.png',
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, AssetImage image, [VoidCallback? onTap]) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: image, width: screenWidth * 0.14, height: screenWidth * 0.14),
            SizedBox(height: screenWidth * 0.03),
            Text(title, style: TextStyle(fontSize: screenWidth * 0.045)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(screenWidth * 0.08),
                bottomRight: Radius.circular(screenWidth * 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: screenHeight * 0.01,
                  offset: Offset(0, screenHeight * 0.005),
                ),
              ],
              image: DecorationImage(
                image: AssetImage('assets/logo-esprit.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
              children: [
                _buildDrawerItem(
                  imagePath: 'assets/studentRed.png',
                  text: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(studentId: widget.studentId),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/teacher.png',
                  text: 'Teacher',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulesPage(studentId: widget.studentId),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/settingred.png',
                  text: 'Setting',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/phoneF.png',
                  text: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacultyContactPage(studentId: widget.studentId),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/stageIm.png',
                  text: 'Internship Management',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                       // builder: (context) => InternshipSubmissionPage(studentId: widget.studentId),
                        //builder: (context) => PdfViewerPage(studentId: widget.studentId),
                         // builder: (context) => Jstagestudent(studentId: widget.studentId),
                         builder: (context) =>  MainNavigationPage(studentId: widget.studentId),


                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/claim.png',
                  text: 'Reclamation',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(

                        builder: (context) =>  ReclamationForm(studentId: widget.studentId),


                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/logout.png',
                  text: 'Log out',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String imagePath,
    required String text,
    required Function() onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        splashColor: Colors.red.shade100,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03, horizontal: screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: screenWidth * 0.015,
                offset: Offset(0, screenWidth * 0.005),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded( // Added Expanded to prevent text overflow
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
