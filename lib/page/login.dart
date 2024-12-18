import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboardTT.dart';
import 'dashborad.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberPassword = prefs.getBool('rememberPassword') ?? false;
      if (rememberPassword) {
        _studentIdController.text = prefs.getString('studentId') ?? '';
      }
    });
  }

  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberPassword) {
      await prefs.setBool('rememberPassword', true);
      await prefs.setString('studentId', _studentIdController.text);
    } else {
      await prefs.setBool('rememberPassword', false);
      await prefs.remove('studentId');
    }
  }

  Future<void> _login() async {
    if (!_formSignInKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String studentId = _studentIdController.text.trim();

    try {
      final response = await http.post(
       // Uri.parse('http://192.168.100.14:3000/login'), // Replace with your login endpoint
        Uri.parse('http://192.168.44.29:3000/login'),



        headers: {'Content-Type': 'application/json'},
        body: json.encode({'studentId': studentId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['message'] == 'Login successful') {
          String userRole = responseData['role'];
          List<dynamic>? userList = responseData['user'];

          if (userList != null && userList.isNotEmpty) {
            String studentId = userList[0];
            String studentName = userList.length > 1 ? userList[1] : 'Unknown';

            await _saveUserPreferences();

            // Save the user session data
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userRole', userRole);
            await prefs.setString('studentId', studentId);
            await prefs.setString('studentName', studentName); // Save the student name

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => userRole == 'student'
                    ? DashboardTT(
                  studentId: studentId,
                  studentName: studentName,
                )
                    : DashboardPage(
                  studentId: studentId,
                ),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'User data is empty or missing.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Unexpected response format or login failed.';
          });
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Column(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: screenHeight * 0.1, // Adjust based on screen height
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.07, // Responsive padding
                    screenHeight * 0.06,
                    screenWidth * 0.07,
                    screenHeight * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08, // Responsive font size
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          TextFormField(
                            controller: _studentIdController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ID Etudiant';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text(
                                'ID Etudiant',
                                style: TextStyle(fontSize: screenWidth * 0.045), // Responsive font size
                              ),
                              hintText: 'Enter ID Etudiant',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: screenWidth * 0.045, // Responsive font size
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor: Colors.red,
                                  ),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: screenWidth * 0.045, // Responsive font size
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: screenWidth * 0.045, // Responsive font size
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05), // Responsive font size
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          if (_errorMessage.isNotEmpty)
                            Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.045), // Responsive font size
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
