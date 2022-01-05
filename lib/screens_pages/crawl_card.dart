import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/firebase_file.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/screens_pages/map_screen.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
//import './pics/bottles.jpg';
//import 'theme.dart';
//import 'card_theme.dart';
import 'package:flutter/widgets.dart';
import '../google/places_api.dart';
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
        title: Text('Crawl list'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PubCrawlModel>>(
          future: list,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  print(snapshot.toString());
                  return Center(child: Text('Some error occurred!'));
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
    const color = Color(0xffA5D5B4);
    String cords;
    List<String> splitCords;
    late var path = FirebaseApi().loadCrawlImage(pubCrawl.imgRef).toString();

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //child: Column(children: [ListTile(title: Text("test"),subtitle: Text("test again"),)],)
      child: InkWell(
        onTap: () async {
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
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            print(snapshot.toString());
                            return Center(child: Text('Some error occurred!'));
                          } else {
                            final url = snapshot.data.toString();

                            return Stack(children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  height: 110,
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                //right: 16,
                                left: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffD9B250),
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
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: Text(pubCrawl.description,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<List<PubCrawlModel>> _loadCrawls() async {
    List<PubCrawlModel> crawls = await FirebaseApi.getCrawl();
    return crawls;
  }

  // Future<String> cordinates(String bar) async {
  //   String cords = await Api.getPlace(bar);
  //   return cords;
  // }

  Future<String> getCrawlImage(String imageName) async {
    String path = await FirebaseApi().loadCrawlImage(imageName);
    return path;
  }
}
