import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_app/screens_pages/favorites.dart';
import 'package:my_first_app/screens_pages/not_signed_in.dart';
import 'package:my_first_app/screens_pages/profile_screen.dart';
import '../screens_pages/crawl_card.dart';
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
          if (FirebaseAuth.instance.currentUser == null)
            NotSignedInScreen()
          else if (FirebaseAuth.instance.currentUser != null)
            Favorites(),
          if (FirebaseAuth.instance.currentUser == null)
            NotSignedInScreen()
          else if (FirebaseAuth.instance.currentUser != null)
            ProfileScreen(),
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
