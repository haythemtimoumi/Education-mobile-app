import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../services/api_service.dart';

class ReclamationForm extends StatefulWidget {
  final String studentId;

  const ReclamationForm({Key? key, required this.studentId}) : super(key: key);

  @override
  _ReclamationFormState createState() => _ReclamationFormState();
}

class _ReclamationFormState extends State<ReclamationForm> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  String? codeCl;
  String? typeRec;
  String description = '';
  String? errorMsg;

  final List<String> reclamationTypes = ['Rec Option', 'Rec Note'];
  bool isFetchingCodeCl = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchClassCode();
  }

  Future<void> _fetchClassCode() async {
    setState(() {
      isFetchingCodeCl = true;
    });
    try {
      String fetchedCodeCl = await apiService.fetchCodeClByStudentId(widget.studentId);
      setState(() {
        codeCl = fetchedCodeCl;
        isFetchingCodeCl = false;
      });
    } catch (error) {
      setState(() {
        isFetchingCodeCl = false;
        errorMsg = 'Failed to fetch Class Code';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch Class Code')),
      );
    }
  }

  Future<void> _submitReclamation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (codeCl != null) {
        setState(() {
          isSubmitting = true;
          errorMsg = null;
        });

        try {
          await apiService.submitReclamation(
            idEt: widget.studentId,
            codeCl: codeCl!,
            typeRec: typeRec!,
            description: description,
          );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Reclamation submitted successfully!'),
            backgroundColor: Colors.green,
          ));
        } catch (error) {
          setState(() {
            errorMsg = 'Failed to submit reclamation: $error';
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red.shade700,
          ));
        } finally {
          setState(() {
            isSubmitting = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please wait for Class Code to be fetched.'),
          backgroundColor: Colors.red.shade700,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Submit Reclamation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title with animation
                FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Reclamation Information',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Glassmorphism card for form fields
                FadeInUp(
                  delay: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 600),
                  child: _buildGlassmorphismCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(screenHeight),
                        SizedBox(height: screenHeight * 0.02),
                        _buildTypeOfReclamationDropdown(),
                        SizedBox(height: screenHeight * 0.02),
                        _buildDescriptionField(),
                        if (errorMsg != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              errorMsg!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Submit button with animation
                FadeInUp(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(milliseconds: 700),
                  child: _buildNeomorphicButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header with student ID and Class code
  Widget _buildHeader(double screenHeight) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Student ID: ${widget.studentId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
            ),
            SizedBox(height: screenHeight * 0.01),
            if (isFetchingCodeCl)
              Center(child: CircularProgressIndicator())
            else if (codeCl != null)
              Text(
                'Classe: $codeCl',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red.shade700),
              )
            else
              Text(
                'Classe not available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700),
              ),
          ],
        ),
      ),
    );
  }

  // Dropdown for selecting reclamation type
  Widget _buildTypeOfReclamationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Type of Reclamation',
        labelStyle: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      value: typeRec,
      items: reclamationTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          typeRec = newValue!;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a Type of Reclamation';
        }
        return null;
      },
    );
  }

  // Description text field
  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: 3,
      onSaved: (value) => description = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  // Glassmorphism card with blur and transparency
  Widget _buildGlassmorphismCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  // Neomorphic gradient submit button
  Widget _buildNeomorphicButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitReclamation,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        child: Text(
          isSubmitting ? 'Submitting...' : 'Submit Reclamation',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
