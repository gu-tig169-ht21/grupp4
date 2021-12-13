import 'package:flutter/material.dart';
import 'package:my_first_app/crawl_details.dart';
import 'package:my_first_app/login_screen.dart';
import 'package:my_first_app/new_account.dart';

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
            Text('crawl view'),
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
            ),
          ],
        ),
      ),
    );
  }
}
