import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'registration_screen.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/registrations.txt');

      // Check if the file exists
      if (!await file.exists()) {
        // Show error message for 2 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No registrations found'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Read the file
      final registrations = await file.readAsString();
      final existingUsers = registrations.split('\n');

      // Check if the username and password match with any of the existing registrations
      for (var user in existingUsers) {
        final userData = user.split(',');
        if (userData.length >= 3 &&
            userData[0] == _usernameController.text &&
            userData[2] == _passwordController.text) {
          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          return;
        }
      }

      // Show error message for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Username or Password'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'My App',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 20),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Not registered?',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up Now',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}