import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class EmploiScreen extends StatefulWidget {
  @override
  _EmploiScreenState createState() => _EmploiScreenState();
}

class _EmploiScreenState extends State<EmploiScreen> {
  final ApiService apiService = ApiService();
  String? selectedClasse;
  DateTime? selectedDate;
  List<List<dynamic>> emploiData = [];
  bool isLoading = false;

  // Mock data for class selection
  final List<String> classes = ['5sleam1', '5sleam2', '5sleam3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emploi du Temps'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Class'),
              value: selectedClasse,
              onChanged: (value) {
                setState(() {
                  selectedClasse = value;
                });
              },
              items: classes.map((String classe) {
                return DropdownMenuItem<String>(
                  value: classe,
                  child: Text(classe),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'YYYY-MM-DD',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024, 1),
                  lastDate: DateTime(2024, 12, 31),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : '',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedClasse != null ? _fetchEmploiData : null,
              child: Text('Fetch Emploi Data'),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: emploiData.isEmpty
                  ? Text('No data available')
                  : ListView.builder(
                itemCount: emploiData.length,
                itemBuilder: (context, index) {
                  final item = emploiData[index];
                  return ListTile(
                    title: Text('Date: ${item[0]}'),
                    subtitle: Text(
                        'Enseignant: ${item[1]}, Module: ${item[5]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchEmploiData() async {
    setState(() {
      isLoading = true;
      emploiData = [];
    });

    try {
      String? date = selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
          : null;
      List<List<dynamic>> data = await apiService.fetchEmploiByClasseAndDate(
        selectedClasse!,
        date: date,
      );
      setState(() {
        emploiData = data;
      });
    } catch (e) {
      print('Error fetching emploi data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load emploi data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
