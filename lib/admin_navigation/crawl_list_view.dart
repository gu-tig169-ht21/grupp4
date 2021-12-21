import 'package:flutter/material.dart';
import 'package:my_first_app/screens_pages/crawl_card.dart';
import 'package:my_first_app/admin_navigation/crawl_details.dart';
import 'package:my_first_app/admin_navigation/start_screen.dart';
import 'package:my_first_app/screens_pages/login_screen.dart';
import 'package:my_first_app/screens_pages/register_user.dart';
import '../cat/interface_theme.dart';

class CrawlView extends StatefulWidget {
  @override
  State<CrawlView> createState() => CrawlViewState();
}

class CrawlViewState extends State<CrawlView> {
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
        title: Text('crawl list'),
        backgroundColor: ColorTheme.a,
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
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Register())),
            ),
            ElevatedButton(
              child: Text('(till en specifik crawl)'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CrawlDetails())),
            ),
            ElevatedButton(
              child: Text('Till start screen'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => StartScreen())),
            ),
            /*  ElevatedButton(
              child: Text('Till map screen'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MapSample())),
            ), */
            ElevatedButton(
              child: Text('Till crawlCard'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CrawlCard())),
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
