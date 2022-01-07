import 'package:flutter/cupertino.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: ColorTheme.a,
        shadowColor: ColorTheme.a,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Expanded(
                flex: 10,
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'You are not signed in to any account. Create a new one or sign in',
                  ),
                ),
              ),
            ),
            ListTile(
              leading: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
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
              trailing: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                ),
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
              ),
            ),
            Container(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              ),
              onLongPress: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => newCrawl())),
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
                child: Text(
                  'View profile screen [developer]',
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
}
