// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import '../google/places_api.dart';

class MapSample extends StatefulWidget {
  final PubCrawlModel crawlModel;

  MapSample({required this.crawlModel});

  @override
  State<MapSample> createState() => MapSampleState(crawlModel: crawlModel);
}

class MapSampleState extends State<MapSample> {
  MapSampleState({required this.crawlModel});
  final PubCrawlModel crawlModel;
  final Set<Marker> _markers = {};
  final List<Pub> _pubs = [];

  late Future<List<Pub>> pubInfoList;
  late AsyncMemoizer _memoizer;

  CameraPosition inital = CameraPosition(
      target: LatLng(57.702870438939414, 11.957678856217141), zoom: 1);

  Future<dynamic> _getListOfPubs() async {
    return _memoizer.runOnce(() async {
      List<String> pubList = crawlModel.pubs.split(";,");
      for (int i = 0; i < pubList.length; i++) {
        _pubs.add(await Api.callGetPubInfo(pubList[i]));
      }
      setState(() {});
    });
  }

  void _fetchMarkers() async {
    List<String> pubList = crawlModel.pubs.split(";,");
    for (int i = 0; i < pubList.length; i++) {
      _markers.add(await Api.callGetPlace(pubList[i]));
    }
    setState(() {});
  }

  final CameraPosition centerGbg = CameraPosition(
    target: LatLng(57.702870438939414, 11.957678856217141),
    zoom: 12.4746,
  );

  void callCamera() async {
    inital = await boundsFromLatLngList();
  }

  Future<CameraPosition> boundsFromLatLngList() async {
    print('hejhej');
    List<String> pubbar = crawlModel.crawlPubs.split(";,");
    List<LatLng> markerList = await Api.reveiveCoordinates(pubbar);
    double lat = 0;
    double lng = 0;
    for (int i = 0; i < markerList.length; i++) {
      print('HÄÄÄÄÄR: ' + markerList[i].toString());
      LatLng toExtract = markerList[i];
      lat += toExtract.latitude;
      lng += toExtract.longitude;
    }
    print('Cameraposition = Lat: ' + lat.toString() + 'Lng: ' + lng.toString());
    lat = lat / markerList.length;
    lng = lng / markerList.length;
    print('CamerapositionCorrect = Lat: ' +
        lat.toString() +
        'Lng: ' +
        lng.toString());
    return CameraPosition(target: LatLng(lat, lng), zoom: 14);
  }

  _onMapCreated(GoogleMapController controller) async {
    print('före future');
    await Future.delayed(Duration(milliseconds: 2500));
    print('Future genomförd');
    controller.animateCamera(CameraUpdate.newCameraPosition(inital));
  }

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
    _fetchMarkers();
    _getListOfPubs();
    callCamera();
  }

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
              child: GoogleMap(
                mapType: MapType.normal,
                //markers: Set<Marker>.from(snapshot.data.values),
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: inital,
                gestureRecognizers: Set()
                  ..add(Factory<EagerGestureRecognizer>(
                      () => EagerGestureRecognizer())),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                  children: _pubs.map((pub) => pubInfoCard(pub)).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget pubInfoCard(Pub pub) {
    String barname = pub.pubname;
    String barnameB4 = pub.pubname.toString();
    if (barnameB4.contains('%20')) {
      barname = barnameB4.replaceAll(RegExp(r'%20'), ' ');
    }
    try {
      String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
      var collection = FirebaseFirestore.instance.collection('User');
      bool isFavourite = false;
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(userEmail).snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                var output = snapshot.data!.data();
                List userFavList =
                    output!['favoriets']; //userFavList = användarens favoriter
                for (var favoriet in userFavList) {
                  if (favoriet == pub.pubname) isFavourite = true;
                }

                return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Card(
                        child: ExpansionTile(
                          trailing: Text('Info ▼'),
                          leading: IconButton(
                            icon: isFavourite
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.amberAccent[400],
                                  )
                                : Icon(Icons.favorite_border),
                            onPressed: () {
                              FirebaseApi.updateFavourite(pub.name);
                              setState(() {});
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
    } catch (e) {
      return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Card(
              child: ExpansionTile(
                trailing: Text('Info ▼'),
                leading: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    //showAlertDialog();
                    const snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      elevation: 10,
                      duration: Duration(milliseconds: 2200),
                      content: Text(
                          'You have to be logged in to save bars to "Favourites"'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      //_pubs.clear();
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
  }
}
