import 'package:flutter/material.dart';

import 'crawl_list.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() {
    return _FavoriteState();
  }
}

class _FavoriteState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
    );
  }
}
