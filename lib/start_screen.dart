import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/login_screen.dart';
import 'package:my_first_app/register_user.dart';
import 'bottom_nav_bar.dart';
import 'crawl_list_view.dart';
import 'favorites.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Screen'),
        backgroundColor: Colors.amberAccent[400],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
              ),
              ElevatedButton(
                child: Text('CRAWL!'),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CrawlView())),
              ),
              ElevatedButton(
                child: Text('Favoriter'),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Favorites())),
              ),
              ElevatedButton(
                child: Text('Lägg till Crawl (Not yet implemented)'),
                onPressed: () =>
                    Navigator.pop(context), //Todo add new crawl class
              ),
              Container(
                height: 200,
              ),
              ElevatedButton(
                child: Text('Logga in'),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())),
              ),
              ElevatedButton(
                child: Text('Skapa konto'),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Register())),
              ),
              ElevatedButton(
                child: Text('(till crawl screen)'),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                height: 30,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onClicked: onItemTapped,
      ),
    );
  }
}
