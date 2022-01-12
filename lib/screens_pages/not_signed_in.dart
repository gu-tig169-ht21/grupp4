// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/screens_pages/new_crawl.dart';
import 'package:my_first_app/screens_pages/register_user.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class NotSignedInScreen extends StatefulWidget {
  @override
  State<NotSignedInScreen> createState() => _NotSignedInScreenState();
}

class _NotSignedInScreenState extends State<NotSignedInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: ColorTheme.a,
        shadowColor: ColorTheme.a,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            infoCard(),
            buttonRow(),
          ],
        ),
      ),
    );
  }

  Widget infoCard() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: const Text(
          'You are not signed in to any account. Create a new one or sign in',
        ),
      ),
    );
  }

  Widget buttonRow() {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 6)),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Register(),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
            child: Text(
              'Create an account',
              style: TextStyle(color: Colors.white),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: ColorTheme.b,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
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
        ),
        const Padding(padding: EdgeInsets.only(top: 25)),
      ],
    );
  }
}
