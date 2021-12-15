import 'package:flutter/material.dart';
import 'package:my_first_app/Authenticate/Authenticate.dart';
import 'package:my_first_app/register_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'crawl_view.dart';

bool showLogout = false;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
          actions: [
            Visibility(
              visible: showLogout,
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<AuthenticationService>().signOut();
                  if (FirebaseAuth.instance.currentUser == null) {
                    showLogout = false;
                    setState(() {});
                  }
                },
                child: Text('Logga ut'),
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Login Screen'),
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
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        labelText: 'Password', border: OutlineInputBorder()),
                  ),
                ),
                ElevatedButton(
                  child: Text('Logga in'),
                  onPressed: () async {
                    //LOGGA IN
                    await context
                        .read<AuthenticationService>()
                        .SignIn(email: _email.text, password: _password.text);
                    print('Firebase USER INFO: ' +
                        FirebaseAuth.instance.currentUser.toString());
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      showLogout = true;
                      setState(() {});
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CrawlView()));
                    }
                  },
                ),
                ElevatedButton(
                  child: Text('Registrera'),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Register())),
                ),
              ],
            ),
          ),
        ));
  }
}
