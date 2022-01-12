// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool admin = false;
  void onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            signinText(),
            emailInput(),
            passwordInput(),
            signinButton(),
          ],
        ),
      ),
    );
  }

  Widget signinText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text('Sign in'),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _email,
        decoration: const InputDecoration(
            labelText: 'Email', border: OutlineInputBorder()),
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 30),
      child: TextField(
        obscureText: true,
        controller: _password,
        decoration: const InputDecoration(
            labelText: 'Password', border: OutlineInputBorder()),
      ),
    );
  }

  Widget signinButton() {
    return ElevatedButton(
      child: const Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        child: Text(
          'Sign in',
          style: TextStyle(color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: ColorTheme.b,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () async {
        //LOGGA IN
        await context
            .read<AuthenticationService>()
            .SignIn(email: _email.text, password: _password.text);
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          setState(() {});
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NavbarPage(),
            ),
          );
        }
      },
    );
  }
}
