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
import '../google/places_api.dart';
import 'login_screen.dart';

class MapSample extends StatefulWidget {
  final PubCrawlModel crawlModel;

  MapSample({required this.crawlModel});

  @override
  State<MapSample> createState() => MapSampleState(crawlModel: crawlModel);
}

class MapSampleState extends State<MapSample> {
  late Future<List<Marker>> markerList;
  final PubCrawlModel crawlModel;
  MapSampleState({required this.crawlModel});
  late List<Pub> pubbar = [];

  Set<Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    setState(() async {
      List<String> pubList = crawlModel.pubs.split(";,");
      for (int i = 0; i < pubList.length; i++) {
        _markers.add(await Api.callGetPlace(pubList[i]));
      }
      // _markers.add(await Api.callGetPlace(pubList[0]));
      // _markers.add(await Api.callGetPlace(pubList[1]));
      // _markers.add(await Api.callGetPlace(pubList[2]));
    });
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

  static final CameraPosition _CenterGbg = CameraPosition(
    target: LatLng(57.702870438939414, 11.957678856217141),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    List<String> pubList = crawlModel.crawlPubs.split(';,');
    /* final List<Pub> pubList = crawlModel.pubs;
    markerList.add(markerLocation()); */
    return new Scaffold(
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
            StatefulBuilder(
              builder: (Context, setState) => Column(
                  children: pubbar.map((pub) => crawlCard(pub)).toList()),
            ),
          ],
        ),
      ),
    );
  }

  //  List<String> barSplits = pubCrawl.crawlPubs.split(';,');
  //         cords = await cordinates(barSplits[0]);
  //         splitCords = cords.split(',');

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Name: ' + pubs.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Adress: ' + pubs.adress,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Description: ' + pubs.description!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
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
                            builder: (context) => LoginScreen()));
                      },
                      child: Text('Log in')),
                ],
              )
            ],
          );
        });
  }

  Widget crawlCard(Pub pubs) {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          child: ExpansionTile(
            leading: IconButton(
              icon: /* pubs.isfavourite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.amberAccent[400],
                    )
                  : */
                  Icon(Icons.favorite_border),
              onPressed: () {
                /*
                if (FirebaseAuth.instance.currentUser == null) {
                  showAlertDialog();
                } else {
                  setState(() {
                    //pubs.isfavourite = !pubs.isfavourite;
                  });
                }*/

                if (pubs.isfavourite) {
                  FavoritesState.favourites.remove(pubs.name);
                  print(FavoritesState.favourites);
                  setState(() {
                    pubs.isfavourite = !pubs.isfavourite;
                  });
                } else {
                  FirebaseApi.updateFavorites(pubs.name);
                  FavoritesState.favourites.add(pubs.name);
                  print(FavoritesState.favourites);
                  setState(() {
                    pubs.isfavourite = !pubs.isfavourite;
                  });
                }
              },
            ),
            title: Text(pubs.pubname),
            children: [
              ListTile(
                title: Text('Name: ' + pubs.pubname),
              ),
              ListTile(
                title: Text('Adress: ' + pubs.adress),
              )
            ],
          ),

          /* ListTile(
                onTap: () {
                  showCustomDialog(pubs, context);
                },
                leading: IconButton(
                  icon: pubs.isfavourite
                      ? Icon(
                          Icons.favorite,
                          color: Colors.amberAccent[400],
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      showAlertDialog();
                    } else {
                      setState(() {
                        pubs.isfavourite = !pubs.isfavourite;
                      });
                    }
                  },
                ),
                title: Text(pubs.pubname),
              ),
          ),*/
        ),
      ],
    );
  }

  Marker addMarkers() {
    List<Marker> markerList = [];
    for (int i = 0; i < crawlModel.crawlPubs.length; i++) {}
    return Marker(
        markerId: MarkerId('Henriksberg'),
        infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(57.699687182039845, 11.936588759846018));
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






  // static final Marker _kGooglePlexMarker = Marker(
  //     markerId: MarkerId('_CenterGbg'),
  //     infoWindow: InfoWindow(title: 'This is the Center of Gothenburg'),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(57.702870438939414, 11.957678856217141));

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(57.7028102, 11.9554687),
  //     tilt: 59.440717697143555,
  //     zoom: 14.0);

  // static final Marker _bar2 = Marker(
  //     markerId: MarkerId('Brygghuset'),
  //     infoWindow: InfoWindow(title: 'Ta en bira!'),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(57.69975767647727, 11.952226705868245));

  // static final Marker _bar3 = Marker(
  //     markerId: MarkerId('Henriksberg'),
  //     infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(57.699687182039845, 11.936588759846018));

  // static final Marker henke = Marker(
  //     markerId: MarkerId('Henriksberg'),
  //     infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(57.699687182039845, 11.936588759846018));

  // static final Polyline _kPolyLine = Polyline(
  //     polylineId: PolylineId('_kPolyLine'),
  //     points: [LatLng(57.708870, 11.974560), LatLng(57.67645, 12.17477)],
  //     width: 5);

  // static final Polygon _kPolygon = Polygon(
  //   polygonId: PolygonId('_kPolygon'),
  //   points: const [
  //     LatLng(57.708870, 11.974560),
  //     LatLng(57.67645, 12.17477),
  //     LatLng(57.4156, 12.8),
  //     LatLng(57.3915, 12.211)
  //   ],
  //   strokeWidth: 5,
  //   fillColor: Colors.transparent,
  // );