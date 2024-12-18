// import 'package:flutter/material.dart';
// import 'maps/mapFac.dart'; // Import the file where your MapScreen is defined
//
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   String? _selectedBlock; // Variable to store the selected block
//   final List<String> _blocks = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // The map will occupy the entire screen
//           Positioned.fill(
//             child: MapScreen(selectedBlock: _selectedBlock), // Pass the selected block
//           ),
//           // Floating back icon at the top left
//           Positioned(
//             top: 20, // Adjust top padding as needed
//             left: 20, // Adjust left padding as needed
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: CircleBorder(),
//                 padding: EdgeInsets.all(10),
//                 elevation: 4, // Shadow effect
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Colors.red.shade700, // Icon color
//                 size: 24, // Icon size
//               ),
//             ),
//           ),
//           // Container for the block selection, positioned at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     spreadRadius: 5,
//                     blurRadius: 10,
//                     offset: Offset(0, -3),
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(16.0), // Add padding for space around the text
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Select Location',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                       fontFamily: 'Roboto', // Modern font
//                     ),
//                   ),
//                   SizedBox(height: 8.0), // Space between text and dropdown
//                   Row(
//                     children: [
//                       Text(
//                         'Select Block:',
//                         style: TextStyle(
//                           fontSize: 17,
//                           color: Colors.red.shade700,
//                           fontFamily: 'Roboto', // Modern font
//                         ),
//                       ),
//                       SizedBox(width: 8.0), // Space between text and dropdown
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: _selectedBlock,
//                           hint: Text('Select Block'),
//                           items: _blocks.map((String block) {
//                             return DropdownMenuItem<String>(
//                               value: block,
//                               child: Text(
//                                 block,
//                                 style: TextStyle(
//                                   fontFamily: 'Roboto', // Modern font
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               _selectedBlock = newValue;
//                             });
//                           },
//                           isExpanded: true, // Make dropdown full-width
//                           underline: SizedBox(), // Remove underline
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
