// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'codeQRview.dart';
//
//
// class ProfileInputPage extends StatefulWidget {
//   @override
//   _ProfileInputPageState createState() => _ProfileInputPageState();
// }
//
// class _ProfileInputPageState extends State<ProfileInputPage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _surnameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _facebookController = TextEditingController();
//   TextEditingController _instagramController = TextEditingController();
//
//   Future<void> _saveData() async {
//     if (_formKey.currentState!.validate()) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('name', _nameController.text);
//       await prefs.setString('surname', _surnameController.text);
//       await prefs.setString('email', _emailController.text);
//       await prefs.setString('facebook', _facebookController.text);
//       await prefs.setString('instagram', _instagramController.text);
//
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ProfileDisplayPage(),  // Navigate to ProfileDisplayPage without named routes
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Profile'),
//         backgroundColor: Colors.red.shade700,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.05),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _buildTextField(_nameController, 'Name'),
//               _buildTextField(_surnameController, 'Surname'),
//               _buildTextField(_emailController, 'Email', isEmail: true),
//               _buildTextField(_facebookController, 'Facebook Link'),
//               _buildTextField(_instagramController, 'Instagram Link'),
//               SizedBox(height: screenWidth * 0.05),
//               ElevatedButton(
//                 onPressed: _saveData,
//                 child: Text('Save'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red.shade700,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   textStyle: TextStyle(fontSize: screenWidth * 0.045),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String labelText, {bool isEmail = false}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter your $labelText';
//           }
//           if (isEmail && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//             return 'Please enter a valid email';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
