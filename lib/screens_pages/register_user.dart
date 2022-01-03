import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';
import '../firebase/storage/storage_services.dart';

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
    TextEditingController _confirmpassword = TextEditingController();

    final AuthenticationService _auth =
        AuthenticationService(FirebaseAuth.instance);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register User'),
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Fill in the following information:'),
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
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: TextField(
                controller: _password,
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _confirmpassword,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
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
                  'Create account',
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
                dynamic result = await _auth.SignUp(
                    email: _email.text, password: _password.text);
                await FirebaseApi.regNewUser(_email.text);
                await _auth.SignIn(
                    email: _email.text, password: _password.text);
                if (result == null) {
                  print('någonting gick fel');
                }
                Navigator.pop(context);
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
