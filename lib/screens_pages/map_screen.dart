// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
      if (_pubs.contains(allPlaces[i])) {
        print(allPlaces[i] + ' finns redan i listan');
      } else {
        _pubs.add(await Api.callGetPubInfo(allPlaces[i]));
      }
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
    zoom: 12.4746,
  );

/*   LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  final _mapController.animateCamera(CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                      southwest: LatLng(latMin, longMin),
                      northeast: LatLng(latMax, longMax),
                  ),
                  100
                )); */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(crawlModel.title),
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
                  markers: _markers,
                  initialCameraPosition: _CenterGbg,
                  gestureRecognizers: Set()
                    ..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
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
    String barname = pub.pubname;
    String barnameB4 = pub.pubname.toString();
    if (barnameB4.contains('%20')) {
      barname = barnameB4.replaceAll(RegExp(r'%20'), ' ');
    }
    bool isFavourite;
    return FutureBuilder(
        future: FirebaseApi.checkIfFavourite(pub.name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String x = snapshot.data.toString();
            if (x == 'true') {
              isFavourite = true;
            } else {
              isFavourite = false;
            }

            return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    child: ExpansionTile(
                      trailing: Text('Info'),
                      leading: IconButton(
                        icon: isFavourite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.amberAccent[400],
                              )
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          FirebaseApi.updateFavourite(pub.name);
                          setState(() {
                            _pubs.clear();
                          });
                        },
                      ),
                      title: Text(barname),
                      children: [
                        ListTile(
                          title: Text('Name: ' + barname),
                        ),
                        ListTile(
                          title: Text('Adress: ' + pub.pubadress),
                        )
                      ],
                    ),
                  ),
                ]);
          } else {
            return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    child: ExpansionTile(
                      trailing: Text('Info'),
                      leading: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.amberAccent[400],
                        ),
                        onPressed: () {
                          showAlertDialog();
                          setState(() {
                            _pubs.clear();
                          });
                        },
                      ),
                      title: Text(barname),
                      children: [
                        ListTile(
                          title: Text('Name: ' + barname),
                        ),
                        ListTile(
                          title: Text('Adress: ' + pub.pubadress),
                        )
                      ],
                    ),
                  ),
                ]);
          }
        });
  }
}
