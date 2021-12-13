import 'package:flutter/material.dart';

import 'crawl_view.dart';

class LoginScreen extends StatelessWidget {
  final textEditingController = TextEditingController();

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
                controller: textEditingController,
                // onSubmitted: (input) {
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Password'),
                controller: textEditingController,
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
