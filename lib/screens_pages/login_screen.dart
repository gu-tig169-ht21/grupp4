import 'package:flutter/material.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:my_first_app/screens_pages/profile_screen.dart';
import 'package:my_first_app/screens_pages/new_crawl.dart';
import 'register_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin_navigation/crawl_list_view.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';

bool showLogout = false;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
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
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Sign in'),
            ),
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              height: 22,
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 15, bottom: 15),
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
                print('Firebase USER INFO: ' +
                    FirebaseAuth.instance.currentUser.toString());
                var user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  showLogout = true;
                  setState(() {});
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NavbarPage(),
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
