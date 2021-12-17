import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

import 'crawl_list_view.dart';
import 'interface_theme.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
        title: Text('Favorites'),
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Here you can view your favorite bars'),
            ElevatedButton(
              child: Text('Back to crawl list'),
              onPressed: () => Navigator.pop(context),
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
