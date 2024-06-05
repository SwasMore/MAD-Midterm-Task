import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/show.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _photoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'https://task-management-backend-vhcq.onrender.com/api/v1/registration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'mobile': _mobileController.text,
          'photo': _photoController.text,
          'password': _passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Registration failed: ${data['message']}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${response.statusCode}, ${response.body}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    label: Text('Email'),
                    icon: Icon(Icons.email),
                    hintText: 'Enter email',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email';
                  } else if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    label: Text('First Name'),
                    icon: Icon(Icons.person),
                    hintText: 'Enter first name',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) =>
                    value!.isEmpty ? 'Enter first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    label: Text('Last Name'),
                    icon: Icon(Icons.person),
                    hintText: 'Enter Last name',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              TextFormField(
                controller: _mobileController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    label: Text('Mobile'),
                    icon: Icon(Icons.mobile_screen_share),
                    hintText: 'Enter mobile no',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) =>
                    value!.isEmpty ? 'Enter mobile number' : null,
              ),
              TextFormField(
                controller: _photoController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    label: Text('Photo URL'),
                    icon: Icon(Icons.picture_in_picture_outlined),
                    hintText: 'Enter photo',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) => value!.isEmpty ? 'Enter photo URL' : null,
              ),
              TextFormField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 16),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text('Password'),
                    icon: Icon(Icons.key),
                    hintText: 'Enter password',
                    hintStyle: TextStyle(color: Colors.grey),
                  )),
              //Text(userName)
              SizedBox(
                height: 30,
              ),

              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: _register,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)))),
      backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15)));
}
