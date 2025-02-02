import 'package:flutter/material.dart';
import 'database_helper.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override MessagingScreenState createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    _messages = await _databaseHelper.getMessages();
    setState(() {});
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    await _databaseHelper.sendMessage({
      'sender_id': 1, // Replace with actual sender ID
      'message': _messageController.text,
      'timestamp': DateTime.now().toString(),
    });
    _messageController.clear();
    await _loadMessages(); // Refresh the message list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messaging')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]['message']),
                  subtitle: Text('Sent by: ${_messages[index]['sender_id']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}