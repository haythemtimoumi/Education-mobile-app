import 'package:flutter/material.dart';
import 'charts/barchartM.dart';
import 'charts/linechart.dart';
import 'charts/radarchart.dart';
import 'stat.dart';
import '../services/api_service.dart'; // Import your ApiService
import 'package:shared_preferences/shared_preferences.dart'; // For caching

class StatFinalPage extends StatefulWidget {
  final String studentId;

  StatFinalPage({required this.studentId});

  @override
  _StatFinalPageState createState() => _StatFinalPageState();
}

class _StatFinalPageState extends State<StatFinalPage> {
  String? codeCl; // To store the fetched CODE_CL
  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCodeCl(); // Fetch CODE_CL when the screen loads
  }

  // Method to fetch CODE_CL and cache it
  Future<void> _fetchCodeCl() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Try to fetch CODE_CL from cache first
      codeCl = prefs.getString('codeCl_${widget.studentId}');

      if (codeCl == null) {
        // Fetch CODE_CL from the API if not found in cache
        codeCl = await apiService.fetchCodeClByStudentId(widget.studentId);

        // Cache the fetched CODE_CL
        await prefs.setString('codeCl_${widget.studentId}', codeCl!);
      }
    } catch (e) {
      print('Error fetching CODE_CL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load class code (CODE_CL)')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsive scaling
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06, // Responsive font size
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent background for modern look
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching CODE_CL
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.12), // Space below AppBar

              // Welcome text
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: screenWidth * 0.08, // Larger modern text
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Explore the student’s statistics and progress.',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Space before cards

              // Modern Cards Section (2 in a row)
              GridView.count(
                shrinkWrap: true, // Make grid take only necessary space
                physics: NeverScrollableScrollPhysics(), // Disable grid scrolling
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: screenWidth * 0.04,
                mainAxisSpacing: screenHeight * 0.03,
                childAspectRatio: screenWidth / (screenHeight * 0.55), // Adjust card aspect ratio
                children: [
                  _buildModernCard(
                    context,
                    'Absence Reporting',
                    'assets/absence.png', // PNG path
                    Colors.greenAccent,
                    StatPage(studentId: widget.studentId), // Pass studentId to StatPage
                    screenHeight,
                    screenWidth,
                  ),
                  _buildModernCard(
                    context,
                    'Progress',
                    'assets/absence.png', // PNG path
                    Colors.orangeAccent,
                    BarChartSample1(studentId: widget.studentId, studentClass: codeCl ?? 'Unknown'), // Use cached CODE_CL
                    screenHeight,
                    screenWidth,
                  ),
                  _buildModernCard(
                    context,
                    'Result Reporting',
                    'assets/absence.png', // PNG path
                    Colors.blueAccent,
                    LineChartSample1(studentId: widget.studentId), // Keep this as is
                    screenHeight,
                    screenWidth,
                  ),
                  _buildModernCard(
                    context,
                    'Student Performance',
                    'assets/absence.png', // PNG path
                    Colors.purpleAccent,
                    RadarChartExample(studentId: widget.studentId), // Navigate to RadarChartExample
                    screenHeight,
                    screenWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern card function with enhanced UI and animation
  Widget _buildModernCard(BuildContext context, String title, String imagePath, Color color, Widget page, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color.withOpacity(0.65)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: screenWidth * 0.15,
              width: screenWidth * 0.15,
              color: Colors.white, // Ensure correct color or replace with another image if needed
            ),
            SizedBox(height: screenHeight * 0.02),
            Flexible( // Ensure text fits without overflow
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.06, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
