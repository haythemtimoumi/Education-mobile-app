import 'package:esprit/page/pdfStage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:animate_do/animate_do.dart'; // For animations
import '../services/api_service.dart'; // Import your ApiService

class InternshipSubmissionPage extends StatefulWidget {
  final String studentId;

  const InternshipSubmissionPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _InternshipSubmissionPageState createState() => _InternshipSubmissionPageState();
}

class _InternshipSubmissionPageState extends State<InternshipSubmissionPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();

  String? _selectedStartDate;
  String? _selectedEndDate;
  bool _isSubmitting = false;

  // Date picker helper
  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade700, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _selectedEndDate = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> _submitInternshipForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStartDate == null || _selectedEndDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select both start and end dates.')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final apiService = ApiService();
      try {
        await apiService.submitInternshipData(
          idEt: widget.studentId,
          dateDebut: _selectedStartDate!,
          dateFin: _selectedEndDate!,
          adresseSociete: _companyAddressController.text,
          telephoneSociete: _companyPhoneController.text,
          nomSociete: _companyNameController.text,
          emailSociete: _companyEmailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Internship submitted successfully!')),
        );

        // Navigate to the PdfViewerPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(studentId: widget.studentId),
          ),
        );

      } catch (e) {
        // Check if the exception is related to form already being submitted
        if (e.toString().contains('once per year')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have already submitted an internship this year.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit internship: $e')),
          );
        }
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Submit Internship Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade700, // Updated color to red.shade700
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated fade-in for the title
                FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Internship Information',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Glassmorphism Card container for the form fields
                FadeInUp(
                  delay: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 600),
                  child: _buildGlassmorphismCard(
                    child: Column(
                      children: [
                        // Start Date picker
                        _buildDateField(
                          label: 'Start Date',
                          selectedDate: _selectedStartDate,
                          onTap: () => _selectDate(context, isStartDate: true),
                        ),

                        // End Date picker
                        _buildDateField(
                          label: 'End Date',
                          selectedDate: _selectedEndDate,
                          onTap: () => _selectDate(context, isStartDate: false),
                        ),

                        // Company Address field
                        _buildTextField(
                          controller: _companyAddressController,
                          label: 'Company Address',
                          hintText: 'Enter company address',
                          imagePath: 'assets/adressF.png',
                          screenWidth: screenWidth,
                        ),

                        // Company Phone field
                        _buildTextField(
                          controller: _companyPhoneController,
                          label: 'Company Phone',
                          hintText: 'Enter company phone',
                          imagePath: 'assets/phoneF.png',
                          screenWidth: screenWidth,
                        ),

                        // Company Name field
                        _buildTextField(
                          controller: _companyNameController,
                          label: 'Company Name',
                          hintText: 'Enter company name',
                          imagePath: 'assets/company.png',
                          screenWidth: screenWidth,
                        ),

                        // Company Email field
                        _buildTextField(
                          controller: _companyEmailController,
                          label: 'Company Email',
                          hintText: 'Enter company email',
                          imagePath: 'assets/emailF.png',
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Neomorphic Gradient Submit button with animation
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

  // Custom DateField widget for Date Pickers
  Widget _buildDateField({
    required String label,
    required String? selectedDate,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icons8-calendar-32.png',
                width: 24,
                height: 24,
                color: Colors.red.shade700, // Optional color tint
              ),
            ),
          ),
          child: Text(
            selectedDate ?? 'Select Date',
            style: TextStyle(
              color: selectedDate != null ? Colors.black : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Glassmorphism Card with subtle blur and transparency
  Widget _buildGlassmorphismCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.all(16.0),
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
      child: child,
    );
  }

  // Custom TextFormField widget to reduce redundancy
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String imagePath,
    required double screenWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imagePath,
              width: screenWidth * 0.07, // Adjust size based on screen width
              height: screenWidth * 0.07,
              color: Colors.red.shade700, // Optionally, you can apply color tint
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Neomorphic Gradient Submit Button
  Widget _buildNeomorphicButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitInternshipForm,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.red.shade700.withOpacity(0.4),
          elevation: 8,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.redAccent.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isSubmitting
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              'Submit',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
