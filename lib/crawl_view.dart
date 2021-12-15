import 'package:flutter/material.dart';
import 'package:my_first_app/crawl_details.dart';
import 'package:my_first_app/favorites.dart';
import 'package:my_first_app/login_screen.dart';
import 'package:my_first_app/new_account.dart';
import 'package:my_first_app/start_screen.dart';


class CrawlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crawl list'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
            child: Text('(till login)'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen())),
            ),
            ElevatedButton(
              child: Text('(till nytt konto)'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewAccountScreen())),
            ),
            ElevatedButton(
              child: Text('(till en specifik crawl)'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CrawlDetails())),
            ElevatedButton(
              child: Text('Till start screen'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => StartScreen())),

            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCard() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(), //bilden
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Do or die'),
                ],
              ),
            ), //texten under
            ButtonBar(), //knapparna
          ],
        ),
      ),
    ),
  );
}