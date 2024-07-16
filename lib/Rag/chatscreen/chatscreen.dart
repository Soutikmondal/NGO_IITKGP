import 'package:flutter/material.dart';
import 'package:patient_app/Rag/ApiService/api_service.dart';

class ChatScreenrag extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenrag> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService('http://10.0.2.2:8000');
  List<Map<String, String>> messages = [];

  void _sendMessage() async {
    String question = _controller.text;
    _controller.clear();

    setState(() {
      messages.add({'role': 'user', 'content': question});
    });

    try {
      String answer = await apiService.askQuestion(question);
      setState(() {
        messages.add({'role': 'bot', 'content': answer});
      });
    } catch (e) {
      setState(() {
        messages.add({'role': 'bot', 'content': 'Failed to get answer'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chatbot',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]['content']!),
                    subtitle: Text(messages[index]['role']!),
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
                      controller: _controller,
                      decoration:
                          InputDecoration(hintText: 'Enter your question'),
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
      ),
    );
  }
}
