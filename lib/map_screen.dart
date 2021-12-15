// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/crawl_card.dart';
import 'package:my_first_app/pub_crawl_model.dart';
import 'bottom_nav_bar.dart';

class MapSample extends StatefulWidget {
  final PubCrawlModel crawlModel;

  MapSample({required this.crawlModel});

  @override
  State<MapSample> createState() => MapSampleState(crawlModel: crawlModel);
}

class MapSampleState extends State<MapSample> {
  //int _selectedIndex = 0;

  final PubCrawlModel crawlModel;

  MapSampleState({required this.crawlModel});

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
    final List<Pub> pubList = crawlModel.pubs;

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextFormField()),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              )
            ],
          ),
          Container(
            height: 275,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {
                _kGooglePlexMarker,
                _bar2,
                _bar3,
                //_kLakeMarker,
              },
              /*polylines: {
                _kPolyLine,
              },
              polygons: {
                _kPolygon,
              },*/
              initialCameraPosition: _CenterGbg,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          StatefulBuilder(
            builder: (Context, setState) =>
                Column(children: pubList.map((pub) => crawlCard(pub)).toList()),
          ),
        ],
      ),
      /* bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.favorite_border_outlined), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ), */
      /*
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goBackToGbg() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_CenterGbg));
  }

  Widget crawlCard(Pub pubs) {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          child: ListTile(
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
            title: Text(pubs.pubname),
            trailing: Icon(Icons.info),
          ),
        ),
        /* Card(
          child: ListTile(
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
            title: Text('Crawl 1'),
            trailing: Icon(Icons.info),
          ),
        ),
        Card(
          child: ListTile(
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
            title: Text('Crawl 1'),
            trailing: Icon(Icons.info),
          ),
        ), */
      ],
    );
  }
}
