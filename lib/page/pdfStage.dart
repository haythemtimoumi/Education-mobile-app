import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart'; // Import the pdfx package
import '../services/api_service.dart'; // Import your ApiService
import 'package:permission_handler/permission_handler.dart'; // For handling permissions
import 'package:path_provider/path_provider.dart'; // For file paths
import 'dart:io'; // For file handling
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // For notifications
import 'package:open_file/open_file.dart'; // For opening files

class PdfViewerPage extends StatefulWidget {
  final String studentId;

  PdfViewerPage({required this.studentId});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfController? pdfController;
  bool isLoading = true;
  String errorMessage = '';
  String? pdfFilePath;

  // Instance of FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _loadPdf();
  }

  // Initialize notification settings
  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadPdf() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch the PDF using your API service
      ApiService apiService = ApiService();
      String filePath = await apiService.fetchPdf(widget.studentId);

      // Store the file path for download purposes
      pdfFilePath = filePath;

      // Load the PDF using pdfx
      setState(() {
        pdfController = PdfController(document: PdfDocument.openFile(filePath));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching the PDF: $e';
        isLoading = false;
      });
    }
  }

  // Function to download the PDF and show notification
  Future<void> _downloadPdf() async {
    if (pdfFilePath == null) return;

    // Check and request storage permission
    if (await Permission.storage.request().isGranted) {
      try {
        // Get the device's download directory
        Directory? downloadsDir = await getExternalStorageDirectory();
        if (downloadsDir != null) {
          String downloadPath = '${downloadsDir.path}/Demande_Stage_${widget.studentId}.pdf';

          // Copy the file to the download directory
          File(pdfFilePath!).copy(downloadPath);

          // Show download notification
          _showDownloadNotification(downloadPath);
        } else {
          throw Exception("Couldn't access the downloads folder.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving PDF: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  // Function to show a notification after the PDF is downloaded
  Future<void> _showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'PDF has been downloaded. Tap to open.',
      platformChannelSpecifics,
      payload: filePath, // Send the file path as payload
    );
  }

  // Handle notification tap to open the file
  Future<void> onNotificationTap(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      await OpenFile.open(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading PDF...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading PDF: $errorMessage'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadPdf, // Retry loading PDF
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf, // Trigger download
          ),
        ],
      ),
      body: pdfController != null
          ? PdfView(controller: pdfController!)
          : Center(child: Text('Unable to load PDF')),
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }
}
