import 'package:flutter/material.dart';
import 'package:my_first_app/screens_pages/map_screen.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
//import './pics/bottles.jpg';
//import 'theme.dart';
//import 'card_theme.dart';
import 'package:flutter/widgets.dart';
import '../google/places_api.dart';
import '../cat/interface_theme.dart';

class CrawlCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.a,
        title: Text('Crawl list'),
      ),
      body: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: buildImageCard(context),
        ),
      ),
    );
  }

  Widget buildImageCard(BuildContext context) {
    String cords;
    List<String> splitCords;
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
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //child: Column(children: [ListTile(title: Text("test"),subtitle: Text("test again"),)],)
      child: InkWell(
        onTap: () async {
          cords = await cordinates();
          splitCords = cords.split(',');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MapSample(
                crawlModel: testCrawl,
                lat: double.parse(splitCords[0]),
                lng: double.parse(splitCords[1]),
              ),
            ),
          );
        },
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
                        //backgroundColor: Colors.amber,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(testCrawl.description,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
            SizedBox(height: 8),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border_outlined)),
                TextButton(
                    onPressed: () {}, child: Text("Learn more / Info / Crawl!"))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> cordinates() async {
    String cords = await Api.getPlace('henriksberg');
    return cords;
  }
}
