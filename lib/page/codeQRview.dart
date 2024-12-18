// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class ProfileDisplayPage extends StatelessWidget {
//   Future<Map<String, String?>> _loadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return {
//       'name': prefs.getString('name'),
//       'surname': prefs.getString('surname'),
//       'email': prefs.getString('email'),
//       'facebook': prefs.getString('facebook'),
//       'instagram': prefs.getString('instagram'),
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Summary'),
//         backgroundColor: Colors.red.shade700,
//       ),
//       body: FutureBuilder<Map<String, String?>>(
//         future: _loadData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No data found.'));
//           }
//
//           final data = snapshot.data!;
//           final qrData = "${data['name']} ${data['surname']}\nEmail: ${data['email']}\nFacebook: ${data['facebook']}\nInstagram: ${data['instagram']}";
//
//           return Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   '${data['name']} ${data['surname']}',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Email: ${data['email']}',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Facebook: ${data['facebook']}',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Instagram: ${data['instagram']}',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 20),
//                 QrImage(
//                   data: qrData,  // Correct usage: data parameter with a String
//                   version: QrVersions.auto,
//                   size: 200.0,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
