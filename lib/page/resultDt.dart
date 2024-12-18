import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentNotesPage extends StatefulWidget {
  final String studentId;

  StudentNotesPage({required this.studentId});

  @override
  _StudentNotesPageState createState() => _StudentNotesPageState();
}

class _StudentNotesPageState extends State<StudentNotesPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> notesP = [];
  List<Map<String, dynamic>> notesR = [];
  bool isLoading = true;
  String selectedType = 'P'; // Default to 'P'

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      List<Map<String, dynamic>> notes = await apiService.fetchStudentNotesById(widget.studentId);
      setState(() {
        notesP = notes.where((note) => note['TYPE_MOY'] == 'P').toList();
        notesR = notes.where((note) => note['TYPE_MOY'] == 'R').toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color for a modern look
      appBar: AppBar(
        title: Text(
          'Student Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06, // Responsive font size
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0, // Flat app bar for a clean look
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.red.shade700,
        ),
      )
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(
                    'TYPE_MOY P',
                    style: TextStyle(
                      color: selectedType == 'P' ? Colors.white : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04, // Responsive font size
                    ),
                  ),
                  selected: selectedType == 'P',
                  selectedColor: Colors.red.shade700,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.red.shade700),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = 'P';
                    });
                  },
                ),
                SizedBox(width: screenWidth * 0.02), // Responsive spacing
                ChoiceChip(
                  label: Text(
                    'TYPE_MOY R',
                    style: TextStyle(
                      color: selectedType == 'R' ? Colors.white : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04, // Responsive font size
                    ),
                  ),
                  selected: selectedType == 'R',
                  selectedColor: Colors.red.shade700,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.red.shade700),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = 'R';
                    });
                  },
                ),
              ],
            ),
          ),
          // Display notes based on the selected TYPE_MOY in a DataTable
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Responsive padding
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red.shade700),
                  headingTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045, // Responsive font size
                  ),
                  columnSpacing: screenWidth * 0.05, // Responsive column spacing
                  columns: [
                    DataColumn(label: Text('Module', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('Exam', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('CC', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('TP', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('Semestre', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('Année', style: TextStyle(fontSize: screenWidth * 0.04))),
                    DataColumn(label: Text('Moyenne', style: TextStyle(fontSize: screenWidth * 0.04))),
                  ],
                  rows: (selectedType == 'P' ? notesP : notesR)
                      .map(
                        (note) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            note['CODE_MODULE'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_EXAM'].toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_CC'].toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_TP'].toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['SEMESTRE'].toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['ANNEE_DEB'].toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['MOYENNE'].toString(),
                            style: TextStyle(
                              color: double.tryParse(note['MOYENNE'].toString())! > 8
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04, // Responsive font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                  dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  dataTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.black87,
                  ),
                  border: TableBorder.all(
                    color: Colors.red.shade700,
                    width: screenWidth * 0.004, // Responsive border width
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: screenWidth * 0.005, // Responsive shadow spread radius
                        blurRadius: screenWidth * 0.012, // Responsive blur radius
                        offset: Offset(0, screenHeight * 0.004), // Responsive offset
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
