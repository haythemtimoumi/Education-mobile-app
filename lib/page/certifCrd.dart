import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart'; // Import your API service
import 'dart:convert';

import 'credit.dart'; // For JSON encoding and decoding

class CreditPage extends StatefulWidget {
  final String studentId;

  CreditPage({required this.studentId});

  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  late Future<Map<String, dynamic>> moyFinalData;
  late Future<Map<String, dynamic>> niveauData;
  String selectedMoyType = 'Semester 1 Average';

  @override
  void initState() {
    super.initState();
    moyFinalData = fetchMoyFinalWithCache(); // Fetch the MoyFinal data with caching
    niveauData = fetchNiveauWithCache(); // Fetch the Niveau data with caching
  }

  Future<Map<String, dynamic>> fetchMoyFinalWithCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedMoyFinal = prefs.getString('moyFinal_${widget.studentId}');

    if (cachedMoyFinal != null) {
      // If cached data exists, return it
      return Future.value(json.decode(cachedMoyFinal));
    } else {
      try {
        // Fetch data from the API
        Map<String, dynamic> data = await ApiService().fetchMoyFinalById(widget.studentId);
        // Save data to cache
        prefs.setString('moyFinal_${widget.studentId}', json.encode(data));
        return data;
      } catch (e) {
        throw Exception('No internet connection and no cached data available');
      }
    }
  }

  Future<Map<String, dynamic>> fetchNiveauWithCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedNiveau = prefs.getString('niveau_${widget.studentId}');

    if (cachedNiveau != null) {
      // If cached data exists, return it
      return Future.value(json.decode(cachedNiveau));
    } else {
      try {
        // Fetch data from the API
        Map<String, dynamic> data = await ApiService().fetchStudentNiveau(widget.studentId);
        // Save data to cache
        prefs.setString('niveau_${widget.studentId}', json.encode(data));
        return data;
      } catch (e) {
        throw Exception('No internet connection and no cached data available');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              FutureBuilder<Map<String, dynamic>>(
                future: moyFinalData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No data available'));
                  } else {
                    final moyFinal = snapshot.data!;
                    Map<String, String> moyValues = {
                      'Semester 1 Average': moyFinal['MOY_SEM1'].toString(),
                      'Semester 2 Average': moyFinal['MOY_SEM2'].toString(),
                      'Overall Average': moyFinal['MOY_GENERAL'].toString(),
                      'Retake Average': moyFinal['MOY_RATT'].toString(),
                    };

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Average Type',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(screenWidth * 0.04),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: DropdownButton<String>(
                              value: selectedMoyType,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.red.shade700),
                              iconSize: screenWidth * 0.08,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.blueGrey.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMoyType = newValue!;
                                });
                              },
                              items: moyValues.keys.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Center(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                              ),
                              child: Container(
                                width: screenWidth * 0.9,
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.blueGrey.shade100],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedMoyType,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade900,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      moyValues[selectedMoyType]!,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: NotesBelowThresholdScreen(studentId: widget.studentId),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.1,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: niveauData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No data available'));
                      } else {
                        final niveau = snapshot.data!;
                        return Container(
                          height: screenHeight * 0.15,
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
                          child: Center(
                            child: Text(
                              'English Level: ${niveau['NIVEAU_COURANT_ANG']}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: niveauData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No data available'));
                      } else {
                        final niveau = snapshot.data!;
                        return Container(
                          height: screenHeight * 0.15,
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
                          child: Center(
                            child: Text(
                              'French Level: ${niveau['NIVEAU_COURANT_FR']}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
