import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:patient_app/chatbotv2/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatScreenv2 extends StatefulWidget {
  const ChatScreenv2({super.key});

  @override
  State<ChatScreenv2> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenv2> {
  List<dynamic> _conversations = [];
  int _currentId = 1;
  List<String> _userResponses = [];
  String userId = "user123";

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    final String response =
        await rootBundle.loadString('assets/conversation.json');
    final data = await json.decode(response);

    setState(() {
      _conversations = data['conversations'];
    });

    final initialConversation = _conversations.firstWhere(
      (conv) => conv['id'] == _currentId,
      orElse: () => null,
    );

    if (initialConversation != null) {
      Provider.of<ChatProviderv2>(context, listen: false)
          .addBotMessage(msg: initialConversation['question']);
    }
  }

  void _handleResponse(int nextId, String response) {
    setState(() {
      _userResponses.add(response);
      _currentId = nextId;
    });

    Provider.of<ChatProviderv2>(context, listen: false)
        .addUserMessage(msg: response);

    final nextConversation = _conversations.firstWhere(
      (conv) => conv['id'] == nextId,
      orElse: () => null,
    );

    if (nextConversation != null) {
      Provider.of<ChatProviderv2>(context, listen: false)
          .addBotMessage(msg: nextConversation['question']);
    }
  }

  Future<void> _saveConversation() async {
    final chatProvider = Provider.of<ChatProviderv2>(context, listen: false);
    final conversationJson =
        jsonEncode(chatProvider.getChatList.map((e) => e.toJson()).toList());

    final response = await http.post(
      Uri.parse('http://10.0.2.2/API/save_conversation.php'),
      body: {
        'user_id': userId,
        'conversation': conversationJson,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Conversation saved successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save conversation')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot V2'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveConversation,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ChatProviderv2>(
          builder: (context, chatProvider, child) {
            // Ensure the current conversation is retrieved from _conversations
            final currentConversation = _conversations.firstWhere(
              (conv) => conv['id'] == _currentId,
              orElse: () => null,
            );

            if (currentConversation == null) {
              return Center(child: Text('Thank you for completing the chat!'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatProvider.getChatList.length,
                    itemBuilder: (context, index) {
                      final chat = chatProvider.getChatList[index];
                      return ListTile(
                        title: Text(
                          chat.msg,
                          style: TextStyle(
                            color: chat.chatIndex == 0
                                ? Colors.blue
                                : Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  currentConversation['question'],
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ...currentConversation['options'].map<Widget>((option) {
                  return ElevatedButton(
                    onPressed: () {
                      _handleResponse(option['next'], option['answer']);
                    },
                    child: Text(option['answer']),
                  );
                }).toList(),
                SizedBox(height: 20),
                Text('Your responses: ${_userResponses.join(', ')}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
