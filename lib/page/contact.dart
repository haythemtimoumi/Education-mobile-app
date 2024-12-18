import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> enseignants = [];
  List<dynamic> filteredEnseignants = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchEnseignants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchEnseignants() async {
    try {
      List<dynamic> enseignantsData = await apiService.fetchEnseignants();
      setState(() {
        enseignants = enseignantsData;
        filteredEnseignants = enseignants;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _filterEnseignants(String query) {
    setState(() {
      searchQuery = query;
      filteredEnseignants = enseignants
          .where((enseignant) =>
      enseignant[9].toLowerCase().contains(query.toLowerCase()) ||
          enseignant[27].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055, // Responsive font size
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 6,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, // Responsive horizontal padding
              vertical: screenHeight * 0.015,  // Responsive vertical padding
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.08), // Responsive border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _filterEnseignants(query);
                  searchQuery = query;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, // Responsive content padding
                    vertical: screenHeight * 0.02,
                  ),
                  hintText: 'Search by name or email',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.04, // Responsive font size
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.red.shade700,
                    size: screenWidth * 0.06, // Responsive icon size
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red.shade700,
                      size: screenWidth * 0.06, // Responsive icon size
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _filterEnseignants('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEnseignants.length,
              itemBuilder: (context, index) {
                final enseignant = filteredEnseignants[index];
                return AnimatedCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // Responsive vertical padding
                      horizontal: screenWidth * 0.05, // Responsive horizontal padding
                    ),
                    title: Text(
                      enseignant[1], // Assuming 1st index is the 'name'
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: enseignant[27])); // Assuming 27th index is the 'email'
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email copied to clipboard')),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/enss.png', // Replace the email icon with the custom image
                            width: screenWidth * 0.08, // Responsive image size
                            height: screenWidth * 0.08, // Responsive image size
                          ),
                          SizedBox(width: screenWidth * 0.02), // Responsive spacing
                          Expanded(
                            child: Text(
                              enseignant[27], // Assuming 27th index is the 'email'
                              style: TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.underline,
                                fontSize: screenWidth * 0.04, // Responsive font size
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      'Service: ${enseignant[5]}', // Assuming 5th index is the 'service'
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045, // Responsive font size
                      ),
                    ),
                    onTap: () {
                      // Handle card tap if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  AnimatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02, // Responsive vertical margin
        horizontal: screenWidth * 0.04, // Responsive horizontal margin
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
