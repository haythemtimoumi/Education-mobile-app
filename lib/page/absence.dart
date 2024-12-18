import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AbsencePage extends StatefulWidget {
  final String studentId;

  AbsencePage({required this.studentId});

  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // No need to initialize notifications or check for new absences with notifications
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04), // Responsive padding
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Absence',
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 4,
        toolbarHeight: screenHeight * 0.08, // Responsive toolbar height
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: apiService.fetchStudentAbsences(widget.studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red.shade700));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No absence records found'));
          }

          final absences = snapshot.data!;

          return ListView.builder(
            itemCount: absences.length,
            itemBuilder: (context, index) {
              final absence = absences[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015, // Responsive vertical margin
                  horizontal: screenWidth * 0.05, // Responsive horizontal margin
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive border radius
                ),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
                            child: Image.asset(
                              'assets/ask.png',
                              width: screenWidth * 0.12, // Responsive image width
                              height: screenWidth * 0.12, // Responsive image height
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04), // Responsive spacing
                          Expanded(
                            child: Text(
                              'Module: ${absence.length > 1 ? absence[8] : 'N/A'}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05, // Responsive font size
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02), // Responsive spacing
                      Divider(
                        color: Colors.red.shade100,
                        thickness: 1,
                      ),
                      SizedBox(height: screenHeight * 0.02), // Responsive spacing
                      _buildAbsenceDetail('Name & Last Name', '${absence[0] ?? 'N/A'} ${absence[1] ?? 'N/A'}', screenWidth),
                      _buildAbsenceDetail('Teacher Name', '${absence[2] ?? 'N/A'} ${absence[4] ?? 'N/A'}', screenWidth),
                      _buildAbsenceDetail('Date', absence.length > 6 ? absence[6] : null, screenWidth),
                      _buildAbsenceDetail('Justification', absence.length > 12 ? absence[12] : null, screenWidth),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAbsenceDetail(String title, String? value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015), // Responsive vertical padding
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Responsive font size
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
