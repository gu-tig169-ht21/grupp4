import 'favorites.dart';
import 'crawl_card.dart';
import 'login_screen.dart';
import 'interface_theme.dart';

import 'package:flutter/material.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({Key? key}) : super(key: key);

  @override
  _NavbarPageState createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Hem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onTappedBar,
        selectedItemColor: Colors.white,
        backgroundColor: ColorTheme.a,
        unselectedItemColor: ColorTheme.f,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          CrawlCard(),
          Favorites(),
          LoginScreen(),
        ],
        onPageChanged: (page) {
          setState(
            () {
              _selectedIndex = page;
            },
          );
        },
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(
      () {
        _selectedIndex = value;
      },
    );
    _pageController.jumpToPage(value);
  }
}