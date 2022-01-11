// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';

bool showLogout = false;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        backgroundColor: ColorTheme.a,
        // actions: [
        //   Visibility(
        //     visible: showLogout,
        //     child: TextButton(
        //       onPressed: () async {
        //         await context.read<AuthenticationService>().signOut();
        //         if (FirebaseAuth.instance.currentUser != null) {
        //           showLogout = true;
        //           setState(() {});
        //         }
        //       },
        //       child: const Text('Logga ut'),
        //     ),
        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Sign in'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _email,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: _password,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
            ),
            Container(
              height: 22,
            ),
            ElevatedButton(
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
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
                  showLogout = true;
                  setState(() {});
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NavbarPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onClicked: onItemTapped,
      // ),
    );
  }
}
