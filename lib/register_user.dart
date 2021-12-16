import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/Authenticate/authenticate.dart';

import 'bottom_nav_bar.dart';
import 'crawl_list_view.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  get _authenticator => null;
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    final AuthenticationService _auth =
        AuthenticationService(FirebaseAuth.instance);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register User'),
        backgroundColor: Colors.amberAccent[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fill info below:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password,
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                dynamic result = await _auth.SignUp(
                    email: _email.text, password: _password.text);
                if (result == null) {
                  print('någonting gick fel');
                }
              },
              child: Text('Skapa användare'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onClicked: onItemTapped,
      ),
    );
  }
}
