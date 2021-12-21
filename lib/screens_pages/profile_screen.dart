import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/screens_pages/login_screen.dart';
import 'package:my_first_app/screens_pages/register_user.dart';

import 'not_signed_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: ColorTheme.a,
        shadowColor: ColorTheme.a,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipPath(
                  child: Container(
                    width: double.infinity,
                    height: 200.0,
                    color: ColorTheme.a,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: profileCard(),
                  ),
                ),
                Positioned.fill(
                  top: 60,
                  left: 153,
                  child: Text(
                    'Hello',
                    style: TextStyle(color: ColorTheme.f),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      leading: Container(width: 120),
                      title: Text(
                        'Username',
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black45,
                                  offset: Offset.fromDirection(45, 3.0),
                                  blurRadius: 10)
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.white),
                      ),
                      trailing: Container(
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 15, bottom: 15),
                child: Text(
                  'Sign out',
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
            Container(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Register(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 15, bottom: 15),
                child: Text(
                  'Register',
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
            Container(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotSignedInScreen(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 15, bottom: 15),
                child: Text(
                  'Log in',
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
          ],
        ),
      ),
    );
  }

  Widget profileCard() {
    return ClipOval(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          const Icon(
            Icons.circle,
            size: 130,
            color: Colors.white60,
          ),
          const Icon(
            Icons.person,
            size: 105,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
