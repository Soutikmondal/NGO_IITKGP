import 'package:flutter/material.dart';
import 'package:patient_app/Chat_Bot/providers/chats_provider.dart';
import 'package:patient_app/chatbotv2/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ChatProviderv2()),
      ],
      child: MaterialApp(
        title: 'User Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginIdController = TextEditingController();
  final _pwdController = TextEditingController();
  String _loginErrorMessage = '';

  void _login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/API/login.php'),
      body: {
        'loginid': _loginIdController.text,
        'pwd': _pwdController.text,
      },
    );

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userType: data['user_type'],
          ),
        ),
      );
    } else {
      setState(() {
        _loginErrorMessage = 'Invalid login credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _loginIdController,
              decoration: const InputDecoration(labelText: 'Login ID'),
            ),
            TextField(
              controller: _pwdController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_loginErrorMessage.isNotEmpty)
              Text(
                _loginErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
