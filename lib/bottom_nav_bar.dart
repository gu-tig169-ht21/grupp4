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
          icon: Icon(Icons.hearing_outlined),
          label: 'Favoriter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Hem',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.miscellaneous_services),
          label: 'Profil',
        )
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: Colors.black,
      backgroundColor: Colors.blue,
      unselectedItemColor: Colors.white,
    );
  }
}
