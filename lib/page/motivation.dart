import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MotivationalMessageWidget extends StatelessWidget {
  final String studentId;

  MotivationalMessageWidget({required this.studentId});

  Future<Map<String, dynamic>> _fetchMessages() async {
    ApiService apiService = ApiService();
    return await apiService.fetchMotivationalMessages(studentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final generalMessage = data['generalMessage'] ?? 'No message available';
          final effortMessage = data['effortMessage'] ?? 'No message available';
          final percentageString = data['academicPeriodPercentage'] ?? '0.00';
          final percentage = double.tryParse(percentageString) ?? 0.0;
          final scoreMessage = data['scoreMessage'] ?? '0'; // Get the scoreMessage

          // Determine the image based on the score
          final imagePath = 'assets/motivation_$scoreMessage.png';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            generalMessage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            effortMessage,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.red.shade50,
                  color: Colors.red.shade700,
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Studying Progress",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${percentage.toStringAsFixed(2)}%", // Display the percentage
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
