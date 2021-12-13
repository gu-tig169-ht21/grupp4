import 'package:flutter/material.dart';

import 'crawl_view.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Login Screen'),
              Text('Här ska det vara en ruta med anv.namn:'),
              Text('Här ska det vara en ruta med password:'),
              ElevatedButton(
                child: Text('(till crawl screen)'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ));
  }
}
