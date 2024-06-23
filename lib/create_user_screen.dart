import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _pwdController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _designationController = TextEditingController();
  final _qualificationController = TextEditingController();
  String _userType = 'adm';
  String _loginIdStatusMessage = '';
  Color _loginIdStatusColor = Colors.black;

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(
              'http://10.0.2.2/API/create_user.php'), 
          body: {
            'loginid': _loginIdController.text,
            'pwd': _pwdController.text,
            'name': _nameController.text,
            'age': _ageController.text,
            'sex': _sexController.text,
            'phone': _phoneController.text,
            'email': _emailController.text,
            'designation': _designationController.text,
            'qualification': _qualificationController.text,
            'user_type': _userType,
          },
        );

      //  print('Response body: ${response.body}'); // Log the response body

        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User created successfully!')),
          );
          _loginIdController.clear();
          _pwdController.clear();
          _nameController.clear();
          _ageController.clear();
          _sexController.clear();
          _phoneController.clear();
          _emailController.clear();
          _designationController.clear();
          _qualificationController.clear();
          setState(() {
            _loginIdStatusMessage = '';
            _loginIdStatusColor = Colors.black;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['message']}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  void _checkLoginId(String loginId) async {
    if (loginId.isEmpty) {
      setState(() {
        _loginIdStatusMessage = '';
        _loginIdStatusColor = Colors.black;
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2/API/check_loginid.php'),
      body: {'loginid': loginId},
    );

    final data = json.decode(response.body);

    setState(() {
      if (data['status'] == 'exists') {
        _loginIdStatusMessage = 'Login ID already exists';
        _loginIdStatusColor = Colors.red;
      } else {
        _loginIdStatusMessage = 'Login ID is available';
        _loginIdStatusColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _loginIdController,
                decoration: InputDecoration(
                  labelText: 'Login ID *',
                  labelStyle: TextStyle(color: _loginIdStatusColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _loginIdStatusColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _loginIdStatusColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a login ID';
                  }
                  return null;
                },
                onChanged: (value) => _checkLoginId(value),
              ),
              SizedBox(height: 5),
              Text(
                _loginIdStatusMessage,
                style: TextStyle(color: _loginIdStatusColor),
              ),
              TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(labelText: 'Password *'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _sexController,
                decoration: InputDecoration(labelText: 'Sex'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone *'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _designationController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(labelText: 'Qualification'),
              ),
              DropdownButton<String>(
                value: _userType,
                items: [
                  DropdownMenuItem(value: 'adm', child: Text('Administrator')),
                  DropdownMenuItem(value: 'doc', child: Text('Doctor')),
                  DropdownMenuItem(value: 'pat', child: Text('Patient')),
                ],
                onChanged: (value) {
                  setState(() {
                    _userType = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _loginIdStatusMessage == 'Login ID is available'
                    ? _createUser
                    : null,
                child: Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
