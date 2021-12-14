import 'package:flutter/material.dart';
import 'package:my_first_app/register.dart';

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
            ElevatedButton(
              child: Text('(till registration'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Register())),
            ),
          ],
        ),
      ),
    );
  }
}
