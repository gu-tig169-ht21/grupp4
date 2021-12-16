import 'package:flutter/material.dart';
import 'package:my_first_app/crawl_details.dart';
import 'package:my_first_app/favorites.dart';
import 'package:my_first_app/login_screen.dart';
import 'package:my_first_app/map_screen.dart';
import 'package:my_first_app/pub_crawl_model.dart';
import 'package:my_first_app/start_screen.dart';
//import './pics/bottles.jpg';
//import 'theme.dart';
//import 'card_theme.dart';
import 'package:flutter/widgets.dart';
import 'interface_theme.dart';

class CrawlCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.a,
        title: Text('Crawl list'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //BuildImageCard(BuildContext context),
          Column(
            children: [
              buildImageCard(context),
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildImageCard(BuildContext context) {
    PubCrawlModel testCrawl = PubCrawlModel(
        crawlID: "123",
        title: "TestCrawl",
        description: "En bra crawl att göra på distans",
        pubs: <Pub>[
          Pub(
              pubID: "1",
              name: "Steampunk",
              adress: "Nybrogatan 3",
              description: "Gammal"),
          Pub(pubID: "2", name: "Brygghuset", adress: "Andra Långgatan 2b"),
          Pub(
              pubID: "3",
              name: "Henriksberg",
              adress: "Gamla vägen 7",
              description: "Fin")
        ]);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MapSample(crawlModel: testCrawl))),
        child: Column(
          children: [
            Stack(
              //alignment: Alignment.center,
              children: [
                Ink.image(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/1283219/pexels-photo-1283219.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Text(
                      testCrawl.title,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(
                testCrawl.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: () {}, child: Text("share")),
                TextButton(onPressed: () {}, child: Text("favoriet"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
