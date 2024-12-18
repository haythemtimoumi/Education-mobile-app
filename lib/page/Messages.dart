import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      itemBuilder: (context, index) {
        bool isUserMessage = messages[index]['isUserMessage'];
        var message = messages[index]['message'];

        // Handle different types of messages (e.g., text, image, etc.)
        String messageText;
        if (message is Map && message.containsKey('text') && message['text'] is Map && message['text'].containsKey('text')) {
          // If the message has the 'text' field, display it
          messageText = message['text']['text'][0];
        } else {
          // Fallback message if the expected structure is not found
          messageText = 'Unsupported message format or no text available';
        }

        return Container(
          margin: EdgeInsets.all(screenWidth * 0.025), // Responsive margin
          child: Row(
            mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.035, // Responsive padding
                  horizontal: screenWidth * 0.035, // Responsive padding
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenWidth * 0.05),
                    topRight: Radius.circular(screenWidth * 0.05),
                    bottomRight: Radius.circular(
                        isUserMessage ? 0 : screenWidth * 0.05),
                    topLeft: Radius.circular(
                        isUserMessage ? screenWidth * 0.05 : 0),
                  ),
                  color: isUserMessage
                      ? Colors.red.shade700
                      : Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxWidth: screenWidth * 2 / 3),
                child: Text(
                  messageText, // Render the message text
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(top: screenWidth * 0.025), // Responsive separator
      ),
      itemCount: messages.length,
    );
  }
}
