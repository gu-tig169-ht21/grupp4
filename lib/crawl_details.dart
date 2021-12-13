import 'package:flutter/material.dart';

import 'crawl_view.dart';

class CrawlDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crawl details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Crawl Details'),
            ElevatedButton(
              child: Text('Tillbaka till crawl list'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
