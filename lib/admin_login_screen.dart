import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _loginIdController = TextEditingController();
  final _pwdController = TextEditingController();

  void _login() async {
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2/API/admin_login.php'), // Change this to your local IP
      body: {
        'loginid': _loginIdController.text,
        'pwd': _pwdController.text,
      },
    );

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  userType: 'adm',
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid login credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _loginIdController,
              decoration: InputDecoration(labelText: 'Login ID'),
            ),
            TextField(
              controller: _pwdController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
