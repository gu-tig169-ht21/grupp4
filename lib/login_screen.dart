import 'package:flutter/material.dart';
import 'package:my_first_app/register.dart';

import 'crawl_view.dart';

class LoginScreen extends StatelessWidget {
  final inputUsername = TextEditingController();
  final inputPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Username'),
                controller: inputUsername,
                // onSubmitted: (input) {
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                controller: inputPassword,
                // onSubmitted: (input) {
              ),
              ElevatedButton(
                child: Text('Log in'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('(till crawl screen)'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('(till registration'),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Register())),
              ),
            ],
          ),
        ));
  }
}
