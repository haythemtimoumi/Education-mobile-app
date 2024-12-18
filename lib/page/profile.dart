import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;

  ProfilePage({required this.studentId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> studentData;
  final ApiService apiService = ApiService();
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late Animation<double> _detailsAnimation;

  @override
  void initState() {
    super.initState();
    studentData = apiService.fetchStudentById(widget.studentId);

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _detailsAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit page or perform an action
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          }

          final student = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                ScaleTransition(
                  scale: _headerAnimation,
                  child: _buildProfileHeader(student, screenWidth, isTablet),
                ),
                SizedBox(height: screenHeight * 0.02),
                FadeTransition(
                  opacity: _detailsAnimation,
                  child: _buildProfileDetailsContainer(student, screenWidth, isTablet),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(List<dynamic> student, double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: isTablet ? 40 : 20),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: isTablet ? screenWidth * 0.12 : screenWidth * 0.15,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/studentRed.png'),
          ),
          SizedBox(height: 20),
          Text(
            '${student[1]} ${student[2]}',
            style: TextStyle(
              fontSize: isTablet ? screenWidth * 0.045 : screenWidth * 0.065,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'ID: ${student[0]}',
            style: TextStyle(
              fontSize: isTablet ? screenWidth * 0.035 : screenWidth * 0.045,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsContainer(List<dynamic> student, double screenWidth, bool isTablet) {
    final details = <Map<String, dynamic>>[
      {'title': 'ID', 'value': student[0], 'icon': Icons.badge},
      {'title': 'Last Name', 'value': student[1], 'icon': Icons.person},
      {'title': 'First Name', 'value': student[2], 'icon': Icons.person_outline},
      {'title': 'Birth Date', 'value': student[3], 'icon': Icons.cake},
      {'title': 'Birth Place', 'value': student[4], 'icon': Icons.location_city},
      {'title': 'Email', 'value': student[10], 'icon': Icons.email},
      {'title': 'Phone', 'value': student[8], 'icon': Icons.phone},
      {'title': 'Address', 'value': student[7], 'icon': Icons.home},
      {'title': 'Nationality', 'value': student[27], 'icon': Icons.flag},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: isTablet ? 40 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(detail['icon'], color: Colors.red.shade700, size: isTablet ? 30 : 24),
              title: Text(
                detail['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? screenWidth * 0.04 : screenWidth * 0.045,
                ),
              ),
              subtitle: Text(
                detail['value']?.toString() ?? 'Not Available',
                style: TextStyle(fontSize: isTablet ? screenWidth * 0.035 : screenWidth * 0.04),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
