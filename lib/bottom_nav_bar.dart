import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomNavBar({required this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoriter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Hem',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        )
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.amberAccent[400],
      unselectedItemColor: Colors.yellow[200],
    );
  }
}
