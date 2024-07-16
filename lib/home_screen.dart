import 'package:flutter/material.dart';
import 'package:patient_app/Chat_Bot/screens/chat_screen.dart';
import 'package:patient_app/Rag/chatscreen/chatscreen.dart';
import 'package:patient_app/chatbotv2/screen/chat_screen.dart';

import 'create_user_screen.dart';
import 'main.dart';

class HomeScreen extends StatelessWidget {
  final String userType;
  final String? userid;
  const HomeScreen({super.key, required this.userType, this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            if (userType == 'adm')
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Create Users'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateUserScreen()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'chat1',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreenrag()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.chat),
          ),
          SizedBox(
              height: 8), // Add some space between the button and the label
          Text('RAG'),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'chat2',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreenv2(userid: userid!)),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.chat),
          ),
          SizedBox(
              height: 8), // Add some space between the button and the label
          Text('Robot'),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'chat3',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(userType: userType)),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.chat),
          ),
          SizedBox(
              height: 8), // Add some space between the button and the label
          Text('Gemini'),
        ],
      ),
    );
  }
}
