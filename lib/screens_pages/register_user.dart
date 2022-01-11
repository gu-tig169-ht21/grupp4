// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';
import '../firebase/storage/storage_services.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  final AuthenticationService _auth =
      AuthenticationService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
        backgroundColor: ColorTheme.a,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            emailInput(),
            passwordInput(),
            confirmPasswordInput(),
            createAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0, bottom: 8.0),
      child: TextField(
        controller: _email,
        decoration: const InputDecoration(
            labelText: 'Email', border: OutlineInputBorder()),
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
      child: TextFormField(
        controller: _password,
        obscureText: true,
        validator: (passwordMatch) {
          if (passwordMatch!.isEmpty)
            return 'You need to confirm your password'; //TODO: fixa någon slags popup/snackbar
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget confirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30),
      child: TextFormField(
        controller: _confirmpassword,
        obscureText: true,
        validator: (passwordMatch) {
          if (passwordMatch!.isEmpty)
            print(
              const Text(
                  'You need to confirm your password'), //TODO: lägg till en popup // snackbar
            );
          if (_confirmpassword.text != _password.text) {
            //WIP
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Confirm password',
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    _password == _confirmpassword ? Colors.pink : Colors.amber),
          ),
        ),
      ),
    );
  }

  Widget createAccountButton() {
    return ElevatedButton(
      child: const Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
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
        dynamic result =
            await _auth.SignUp(email: _email.text, password: _password.text);
        await FirebaseApi.regNewUser(_email.text);
        await _auth.SignIn(email: _email.text, password: _password.text);
        if (result == null) {}
        if (_password.text == _confirmpassword.text) {
          setState(() {});
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NavbarPage(),
            ),
          );
        }
      },
    );
  }
}
