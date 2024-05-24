
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inte/API/view/ApiService.dart';
import 'package:inte/API/model/ChatModel.dart';

class ChatScreen extends StatefulWidget {
  final List<String> messages;

  ChatScreen({required this.messages});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages = widget.messages;
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add(_messageController.text);
    });

    String prompt = _messageController.text;
    _messageController.clear();

    try {
      List<ChatModel> responses = await ApiService.sendMessage(
        message: prompt,
        modelId: 'gpt-3.5-turbo-0301',
      );

      List<String> messages = responses.map((e) => e.msg).toList();

      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with AI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_messages[index]),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

