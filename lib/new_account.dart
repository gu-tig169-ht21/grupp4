import 'package:flutter/material.dart';

import 'crawl_view.dart';

class NewAccountScreen extends StatelessWidget {
  final inputUsername = TextEditingController();
  final inputPassword = TextEditingController();
  final inputPasswordConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create new account'),
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
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm password'),
                controller: inputPasswordConfirm,
                // onSubmitted: (input) {
              ),
              ElevatedButton(
                child: Text('(till crawl screen)'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ));
  }
}
