import 'package:esprit/page/dashboardTT.dart';
import 'package:esprit/page/dashborad.dart';
import 'package:esprit/page/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is logged in
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userRole = prefs.getString('userRole');
  String? studentId = prefs.getString('studentId');
  String? studentName = prefs.getString('studentName'); // Retrieve the student name

  Widget homeWidget;

  if (isLoggedIn && userRole != null && studentId != null && studentName != null) {
    homeWidget = userRole == 'student'
        ? DashboardTT(studentId: studentId, studentName: studentName)
        : DashboardPage(studentId: studentId);
  } else {
    homeWidget = LoginPage();
  }

  runApp(MyApp(homeWidget: homeWidget));
}

class MyApp extends StatelessWidget {
  final Widget homeWidget;

  MyApp({required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: homeWidget,
    );
  }
}
