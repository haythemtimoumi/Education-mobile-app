import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/module.dart';
import 'resultDt.dart';

class ResultPage extends StatefulWidget {
  final String studentId;

  ResultPage({required this.studentId});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String selectedOption = 'Resultat Principale';
  late Future<List<StudentModule>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    _modulesFuture = _fetchModules();
  }

  Future<List<StudentModule>> _fetchModules() async {
    final apiService = ApiService();
    List<StudentModule> modules;

    if (selectedOption == 'Resultat Principale') {
      modules = await apiService.fetchStudentModules(widget.studentId);
    } else {
      modules = await apiService.fetchStudentModulesR(widget.studentId);
    }

    return modules;
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedOption = newValue;
        _modulesFuture = _fetchModules();
      });
    }
  }

  void _onMoreIconTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentNotesPage(studentId: widget.studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        title: Text(
          'Modules',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055, // Responsive font size
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons8-search-128.png',
              width: screenWidth * 0.06, // Responsive icon size
              height: screenWidth * 0.06, // Responsive icon size
              color: Colors.white,
            ),
            onPressed: _onMoreIconTapped,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, // Responsive padding
              vertical: screenHeight * 0.015, // Responsive padding
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045, // Responsive font size
                    ),
                    dropdownColor: Colors.white,
                    items: <String>['Resultat Principale', 'Controle']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _onDropdownChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StudentModule>>(
              future: _modulesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screenWidth * 0.045, // Responsive font size
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No modules found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.045, // Responsive font size
                      ),
                    ),
                  );
                }

                final modules = snapshot.data!;

                final groupedModules = <String, List<StudentModule>>{};
                for (var module in modules) {
                  if (!groupedModules.containsKey(module.libUE)) {
                    groupedModules[module.libUE] = [];
                  }
                  groupedModules[module.libUE]!.add(module);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04, // Responsive padding
                    vertical: screenHeight * 0.015, // Responsive padding
                  ),
                  itemCount: groupedModules.length,
                  itemBuilder: (context, index) {
                    final libUE = groupedModules.keys.elementAt(index);
                    final moduleList = groupedModules[libUE]!;
                    final averageGrade = moduleList.fold<double>(0, (sum, module) => sum + module.moyenneModule) / moduleList.length;

                    final bool isHighAverage = averageGrade > 8;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // Responsive margin
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04), // Responsive border radius
                      ),
                      color: isHighAverage ? Colors.green[50] : Colors.red[50],
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lib U.E: $libUE',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045, // Responsive font size
                              ),
                            ),
                            Divider(color: Colors.grey[300]),
                            ...moduleList.map((module) {
                              final isHighGrade = module.moyenneModule > 8;
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005), // Responsive padding
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${module.designationModule.split('\r')[0]}',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: screenWidth * 0.04, // Responsive font size
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${module.moyenneModule.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isHighGrade ? Colors.green : Colors.red,
                                        fontSize: screenWidth * 0.04, // Responsive font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            Divider(color: Colors.grey[300]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Average Grade: ${averageGrade.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.04, // Responsive font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  isHighAverage ? Icons.thumb_up : Icons.thumb_down,
                                  color: isHighAverage ? Colors.green : Colors.red,
                                  size: screenWidth * 0.06, // Responsive icon size
                                ),
                              ],
                            ),
                            if (!isHighAverage)
                              Padding(
                                padding: EdgeInsets.only(top: screenHeight * 0.01), // Responsive padding
                                child: Text(
                                  'Needs Improvement',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenWidth * 0.035, // Responsive font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
