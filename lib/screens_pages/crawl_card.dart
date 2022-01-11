// ignore_for_file: use_key_in_widget_constructors

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/firebase_file.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/screens_pages/map_screen.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
//import './pics/bottles.jpg';
//import 'theme.dart';
//import 'card_theme.dart';
import '../cat/interface_theme.dart';

class CrawlCard extends StatefulWidget {
  @override
  State<CrawlCard> createState() => _CrawlCardState();
}

class _CrawlCardState extends State<CrawlCard> {
  late Future<List<PubCrawlModel>> list;
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();

    list = FirebaseApi.getCrawl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.a,
        title: const Text('Crawl list'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PubCrawlModel>>(
          future: list,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  final list = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: buildImageCard(context, list[index]),
                          ),
                        ),
                      ),
                    ],
                  );
                }
            }
          }),
    );
  }

  Widget buildImageCard(BuildContext context, PubCrawlModel pubCrawl) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //child: Column(children: [ListTile(title: Text("test"),subtitle: Text("test again"),)],)
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MapSample(
                crawlModel: pubCrawl,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Stack(
              //alignment: Alignment.center,
              children: [
                FutureBuilder(
                    future: getCrawlImage(pubCrawl.imgRef),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Some error occurred!'));
                          } else {
                            final url = snapshot.data.toString();

                            return Stack(children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.scaleDown,
                                  height: 240,
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                //right: 16,
                                left: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffD9B250),
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      pubCrawl.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        //backgroundColor: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]);
                          }
                      }
                    })
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: ExpandablePanel(
                header: Text(
                  pubCrawl.title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                collapsed: Text(
                  pubCrawl.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  softWrap: true,
                  maxLines: 1,
                ),
                expanded: Text(
                  pubCrawl.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getCrawlImage(String imageName) async {
    String path = await FirebaseApi().loadCrawlImage(imageName);
    return path;
  }
}
