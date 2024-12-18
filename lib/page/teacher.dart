import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import '../services/api_service.dart';

class ModulesPage extends StatefulWidget {
  final String studentId;

  ModulesPage({required this.studentId});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  late Future<List<Map<String, dynamic>>> modulesWithEnseignants;
  List<Map<String, dynamic>> allModules = [];
  List<Map<String, dynamic>> filteredModules = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  void fetchModules() async {
    modulesWithEnseignants =
        ApiService().fetchModulesWithEnseignantsByStudent(widget.studentId);
    modulesWithEnseignants.then((data) {
      setState(() {
        allModules = data;
        filteredModules = data;
      });
    }).catchError((error) {
      print("Error: $error");
    });
  }

  // Updated filterModules function to also search by email
  void filterModules(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredModules = allModules.where((module) {
        final libUE = module['LIB_UE']?.toLowerCase() ?? '';
        final nomEns1 = module['NOM_ENS1']?.toLowerCase() ?? '';
        final email1 = module['EMAIL_1']?.toLowerCase() ?? '';
        final nomEns2 = module['NOM_ENS2']?.toLowerCase() ?? '';
        final email2 = module['EMAIL_2']?.toLowerCase() ?? '';
        final nomEns3 = module['NOM_ENS3']?.toLowerCase() ?? '';
        final email3 = module['EMAIL_3']?.toLowerCase() ?? '';
        final nomEns4 = module['NOM_ENS4']?.toLowerCase() ?? '';
        final email4 = module['EMAIL_4']?.toLowerCase() ?? '';
        final nomEns5 = module['NOM_ENS5']?.toLowerCase() ?? '';
        final email5 = module['EMAIL_5']?.toLowerCase() ?? '';

        // Check if query matches any module name, enseignant name, or email
        return libUE.contains(searchQuery) ||
            nomEns1.contains(searchQuery) ||
            email1.contains(searchQuery) ||
            nomEns2.contains(searchQuery) ||
            email2.contains(searchQuery) ||
            nomEns3.contains(searchQuery) ||
            email3.contains(searchQuery) ||
            nomEns4.contains(searchQuery) ||
            email4.contains(searchQuery) ||
            nomEns5.contains(searchQuery) ||
            email5.contains(searchQuery);
      }).toList();
    });
  }

  // Function to copy email to clipboard
  void copyToClipboard(String email) {
    Clipboard.setData(ClipboardData(text: email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $email to clipboard'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding, font sizes, and margins based on screen size
    final double padding = screenWidth * 0.05; // 5% of screen width
    final double titleFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double cardPadding = screenWidth * 0.04; // 4% of screen width
    final double enseignantFontSize = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      backgroundColor: Colors.grey[100], // Modern light background color
      appBar: AppBar(
        title: Text(
          'Find Your Ensignants',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar for filtering
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextField(
              onChanged: (value) => filterModules(value),
              decoration: InputDecoration(
                hintText: 'Search by subject, enseignant name, or email...',
                prefixIcon: Icon(Icons.search, color: Colors.red.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(color: Colors.black, fontSize: enseignantFontSize),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: modulesWithEnseignants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.red.shade700));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.red.shade700, fontSize: enseignantFontSize),
                        ),
                        SizedBox(height: 10),
                        Text('Please check your internet connection and try again.', style: TextStyle(fontSize: enseignantFontSize)),
                      ],
                    ),
                  );
                } else if (filteredModules.isEmpty) {
                  return Center(
                    child: Text(
                      'No modules or enseignants found',
                      style: TextStyle(fontSize: enseignantFontSize, fontWeight: FontWeight.w500),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredModules.length,
                    itemBuilder: (context, index) {
                      final module = filteredModules[index];

                      // Filter out null or empty enseignants and emails
                      final enseignantList = [
                        {
                          'name': module['NOM_ENS1'],
                          'email': module['EMAIL_1']
                        },
                        {
                          'name': module['NOM_ENS2'],
                          'email': module['EMAIL_2']
                        },
                        {
                          'name': module['NOM_ENS3'],
                          'email': module['EMAIL_3']
                        },
                        {
                          'name': module['NOM_ENS4'],
                          'email': module['EMAIL_4']
                        },
                        {
                          'name': module['NOM_ENS5'],
                          'email': module['EMAIL_5']
                        }
                      ].where((e) => e['name'] != null && e['name'].trim().isNotEmpty).toList();

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school_rounded, color: Colors.red.shade700, size: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    module['LIB_UE'],
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02), // Responsive height
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: enseignantList.map((enseignant) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.person_rounded,
                                        color: Colors.grey[700],
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          enseignant['name']!,
                                          style: TextStyle(fontSize: enseignantFontSize, color: Colors.black87),
                                        ),
                                      ),
                                      if (enseignant['email'] != null && enseignant['email'].trim().isNotEmpty)
                                        IconButton(
                                          icon: Icon(Icons.copy, color: Colors.red.shade700),
                                          onPressed: () {
                                            copyToClipboard(enseignant['email']!);
                                          },
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
