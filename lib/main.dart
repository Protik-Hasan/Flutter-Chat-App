import 'package:chat_app/home_page.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:flutter/services.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/logout', // Set the initial route to your login screen
      routes: {
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(name: 'Protik Hasan', email: 'protik@gmail.com'),
        '/logout': (context) => LoginPage(),
      },
    );
  }
}