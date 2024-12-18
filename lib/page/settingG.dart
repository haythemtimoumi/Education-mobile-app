import 'package:flutter/material.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, screenWidth),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06, // Responsive padding
                  vertical: screenHeight * 0.03, // Responsive padding
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(screenWidth),
                    SizedBox(height: screenHeight * 0.04), // Responsive spacing
                    _buildSettingsOption(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        // Implement password change functionality
                      },
                      screenWidth: screenWidth,
                    ),
                    _buildSettingsOption(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Update Phone Number',
                      onTap: () {
                        // Implement phone number update functionality
                      },
                      screenWidth: screenWidth,
                    ),
                    _buildSettingsOption(
                      context,
                      icon: Icons.perm_identity,
                      title: 'Update Nationality Number',
                      onTap: () {
                        // Implement nationality number update functionality
                      },
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.04), // Responsive spacing
                    _buildLogoutButton(context, screenWidth),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.04, // Responsive padding
        horizontal: screenWidth * 0.06, // Responsive padding
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_new, color: Colors.red.shade700),
          ),
          SizedBox(width: screenWidth * 0.04), // Responsive spacing
          Expanded(
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenWidth * 0.065, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
      ),
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Row(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.12, // Responsive radius
            backgroundColor: Colors.red.shade700,
            child: Text(
              'JD', // Initials
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.06, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.05), // Responsive spacing
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: screenWidth * 0.055, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.015), // Responsive spacing
              Text(
                '+1 234 567 890',
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: screenWidth * 0.01), // Responsive spacing
              Text(
                'Nationality: 123456789',
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Function() onTap,
        required double screenWidth,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
          border: Border.all(color: Colors.grey.shade300),
        ),
        margin: EdgeInsets.only(bottom: screenWidth * 0.04), // Responsive margin
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Responsive padding
            vertical: screenWidth * 0.04, // Responsive padding
          ),
          leading: Icon(
            icon,
            color: Colors.red.shade700,
            size: screenWidth * 0.07, // Responsive icon size
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.045, // Responsive font size
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade400,
            size: screenWidth * 0.05, // Responsive icon size
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, double screenWidth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.05, // Responsive padding
          horizontal: screenWidth * 0.2, // Responsive padding
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
        ),
        elevation: 0,
      ),
      onPressed: () {
        // Implement logout logic here
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Center(
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
