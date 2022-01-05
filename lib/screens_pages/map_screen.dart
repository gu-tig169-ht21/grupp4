// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/screens_pages/crawl_card.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:my_first_app/screens_pages/favorites.dart';
import 'package:my_first_app/screens_pages/not_signed_in.dart';
import '../google/places_api.dart';
import 'login_screen.dart';

class MapSample extends StatefulWidget {
  final PubCrawlModel crawlModel;

  MapSample({required this.crawlModel});

  @override
  State<MapSample> createState() => MapSampleState(crawlModel: crawlModel);
}

class MapSampleState extends State<MapSample> {
  MapSampleState({required this.crawlModel});
  final PubCrawlModel crawlModel;

  late Future<List<Marker>> markerList;
  late Future<List<Pub>> pubInfoList;

  final Set<Marker> _markers = {};
  final List<Pub> _pubs = [];

  Future<List<Pub>> _getListOfPubs() async {
    List<String> allPlaces = crawlModel.pubs.split(";,");
    for (int i = 0; i < allPlaces.length; i++) {
      _pubs.add(await Api.callGetPubInfo(allPlaces[i]));
    }
    return _pubs;
  }

  void _onMapCreated(GoogleMapController controller) async {
    List<String> pubList = crawlModel.pubs.split(";,");
    for (int i = 0; i < pubList.length; i++) {
      _markers.add(await Api.callGetPlace(pubList[i]));
    }
  }

  //int _selectedIndex = 0;

  //Måste göra en metod av det hela istället för att initiera allt i "initalizern"

  @override
  void initState() {
    super.initState();
    markerList = Api.callAllPlaces(crawlModel.pubs);
  }
  /* void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  } */

  //Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _CenterGbg = CameraPosition(
    target: LatLng(57.702870438939414, 11.957678856217141),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Maps'),
        backgroundColor: ColorTheme.a,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 275,
              child: FutureBuilder(
                future: markerList,
                builder: (context, snapshot) => GoogleMap(
                  mapType: MapType.normal,
                  //markers: Set<Marker>.from(snapshot.data.values),
                  onMapCreated: _onMapCreated,
                  markers: _markers, initialCameraPosition: _CenterGbg,
                ),
              ),
            ),
            SingleChildScrollView(
              child: FutureBuilder(
                future: _getListOfPubs(),
                builder: (context, snapshot) => Column(
                    children: _pubs.map((pub) => pubInfoCard(pub)).toList()),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showCustomDialog(Pub pub, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Name: ' + pub.pubname,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                /* ListTile(
                  title: Text(
                    'Adress: ' + pubs.adress,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ), */
                /* ListTile(
                  title: Text(
                    'Description: ' + pubs.description!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ), */
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
              ],
            ),
          );
        });
  }

  void showNotLoggedInDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('You have to log in to save favoriets!!!',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            )),
          );
        });
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert!'),
            content: Text('You have to log in to save favourites'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Keep crawling')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NotSignedInScreen()));
                      },
                      child: Text('Log in')),
                ],
              )
            ],
          );
        });
  }

  Widget pubInfoCard(Pub pub) {
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Card(
            child: ExpansionTile(
              trailing: Text('Info'),
              leading: IconButton(
                icon: pub.isfavourite
                    ? Icon(
                        Icons.favorite,
                        color: Colors.amberAccent[400],
                      )
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    showAlertDialog();
                  } else {
                    print('Denna pub: ' + pub.pubname);
                    bool check = false; //

                    setState(() {
                      print('Vi är inloggade!!');
                      print('innan förändring' + pub.isfavourite.toString());
                      pub.isfavourite = !pub.isfavourite;
                      print('efter förändring: ' + pub.isfavourite.toString());
                    });
                  }

                  if (pub.isfavourite) {
                    print('puben är favorit');
                    FavoritesState.favourites.remove(pub.name);
                    print(FavoritesState.favourites);
                    setState(() {
                      pub.isfavourite = !pub.isfavourite;
                    });
                  } else {
                    print('puben är inte favorit');
                    FirebaseApi.checkIfFavorite(pub.name);
                    print('puben vi vill ha som favorit: ' + pub.name);
                    FavoritesState.favourites.add(pub.name);
                    print('HEJ!' + FavoritesState.favourites.toString());
                    setState(() {
                      pub.isfavourite = !pub.isfavourite;
                    });
                  }
                },
              ),
              title: Text(pub.pubname),
              children: [
                ListTile(
                  title: Text('Name: ' + pub.pubname),
                ),
                ListTile(
                  title: Text('Adress: ' + pub.pubadress),
                )
              ],
            ),
          ),
        ]);
  }
}
