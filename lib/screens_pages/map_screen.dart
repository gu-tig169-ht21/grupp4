// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/screens_pages/crawl_card.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import '../google/places_api.dart';

List<Marker> markerList = [];

class MapSample extends StatefulWidget {
  final PubCrawlModel crawlModel;
  double lat;
  double lng;

  MapSample({required this.crawlModel, required this.lat, required this.lng});

  @override
  State<MapSample> createState() =>
      MapSampleState(crawlModel: crawlModel, lat: lat, lng: lng);
}

class MapSampleState extends State<MapSample> {
  //int _selectedIndex = 0;

  final PubCrawlModel crawlModel;
  double lat;
  double lng;
  //Måste göra en metod av det hela istället för att initiera allt i "initalizern"
  MapSampleState(
      {required this.crawlModel, required this.lat, required this.lng});
  /* void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  } */

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _CenterGbg = CameraPosition(
    target: LatLng(57.702870438939414, 11.957678856217141),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_CenterGbg'),
      infoWindow: InfoWindow(title: 'This is the Center of Gothenburg'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.702870438939414, 11.957678856217141));

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(57.7028102, 11.9554687),
      tilt: 59.440717697143555,
      zoom: 14.0);

  static final Marker _bar2 = Marker(
      markerId: MarkerId('Brygghuset'),
      infoWindow: InfoWindow(title: 'Ta en bira!'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.69975767647727, 11.952226705868245));

  static final Marker _bar3 = Marker(
      markerId: MarkerId('Henriksberg'),
      infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.699687182039845, 11.936588759846018));

  static final Marker henke = Marker(
      markerId: MarkerId('Henriksberg'),
      infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.699687182039845, 11.936588759846018));

  static final Polyline _kPolyLine = Polyline(
      polylineId: PolylineId('_kPolyLine'),
      points: [LatLng(57.708870, 11.974560), LatLng(57.67645, 12.17477)],
      width: 5);

  static final Polygon _kPolygon = Polygon(
    polygonId: PolygonId('_kPolygon'),
    points: [
      LatLng(57.708870, 11.974560),
      LatLng(57.67645, 12.17477),
      LatLng(57.4156, 12.8),
      LatLng(57.3915, 12.211)
    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    /* final List<Pub> pubList = crawlModel.pubs;
    markerList.add(markerLocation()); */

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Maps'),
        backgroundColor: Colors.amberAccent[400],
      ),
      body: Column(
        children: [
          Container(
            height: 275,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {
                _kGooglePlexMarker,
                _bar2,
                new Marker(
                    markerId: MarkerId('Henriksberg'),
                    infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(lat, lng)),
                //markerList[0],
                //markerLocation(),
              },
              initialCameraPosition: _CenterGbg,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          /* StatefulBuilder(
            builder: (Context, setState) =>
                Column(children: pubList.map((pub) => crawlCard(pub)).toList()),
          ), */
        ],
      ),
    );
  }

  // markerLocation() async {
  //   String cords = await Api.getPlace('henriksberg');
  //   List<String> splitCords = cords.split(',');
  //   double lat = double.parse(splitCords[0]);
  //   double lng = double.parse(splitCords[1]);
  //   return Marker(
  //     markerId: MarkerId('Henkeberg'),
  //     infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(lat, lng),
  //   );
  // }

  void showCustomDialog(Pub pubs, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 450,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Name: ' + pubs.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Adress: ' + pubs.adress,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Description: ' + pubs.description!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                ],
              ),
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

  Widget crawlCard(Pub pubs) {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          child: ListTile(
            onTap: () {
              showCustomDialog(pubs, context);
            },
            leading: IconButton(
              icon: /* pubs.isfavourite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.amberAccent[400],
                    )
                  : */
                  Icon(Icons.favorite_border),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  showNotLoggedInDialog();
                } else {
                  setState(() {
                    //pubs.isfavourite = !pubs.isfavourite;
                  });
                }
              },
            ),
            title: Text(pubs.pubname),
          ),
        ),
      ],
    );
  }
}

// class addMarkerLocations {
//   markerLocation() async {
//     String cords = await Api.getPlace('henriksberg');
//     List<String> splitCords = cords.split(',');
//     double lat = double.parse(splitCords[0]);
//     double lng = double.parse(splitCords[1]);
//     return Marker(
//       markerId: MarkerId('Henkeberg'),
//       infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
//       icon: BitmapDescriptor.defaultMarker,
//       position: LatLng(lat, lng),
//     );
//   }
// }
