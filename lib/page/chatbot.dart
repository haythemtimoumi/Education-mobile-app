import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    initializeDialogFlowtter();
    loadMessagesFromCache();
  }

  // Initialize DialogFlowtter
  Future<void> initializeDialogFlowtter() async {
    try {
      dialogFlowtter = DialogFlowtter();
    } catch (e) {
      print('Error initializing DialogFlowtter: $e');
    }
  }

  // Load messages from cache
  void loadMessagesFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedMessages = prefs.getString('cachedMessages');
    if (cachedMessages != null) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(cachedMessages));
      });
    }
  }

  // Save messages to cache
  void saveMessagesToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedMessages', json.encode(messages));
  }

  // Clear messages from cache
  void clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cachedMessages');
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        actions: [
          // Add an icon to clear all messages
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: clearCache, // Clear cache and messages
          ),
        ],
        backgroundColor: Colors.red.shade700,
      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Send a message and save it to cache
  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
      return;
    }

    setState(() {
      addMessage({'text': text, 'isUserMessage': true});
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message != null) {
      setState(() {
        addMessage({'text': response.message?.text?.text?[0], 'isUserMessage': false});
      });
      saveMessagesToCache(); // Save to cache after each message
    }
  }

  // Add a message to the message list
  void addMessage(Map<String, dynamic> message) {
    messages.add(message);
  }
}

// A simple message screen widget to display messages
class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        bool isUserMessage = messages[index]['isUserMessage'];
        return Align(
          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.red.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              messages[index]['text'] ?? 'Error: No message',
              style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
