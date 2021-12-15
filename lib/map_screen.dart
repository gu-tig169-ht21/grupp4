// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bottom_nav_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _CenterGbg = CameraPosition(
    target: LatLng(57.708870, 11.974560),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_CenterGbg'),
      infoWindow: InfoWindow(title: 'This is the Center of Gothenburg'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.708870, 11.974560));

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(57.67645, 12.17477),
      tilt: 59.440717697143555,
      zoom: 14.0);

  static final Marker _kLakeMarker = Marker(
      markerId: MarkerId('_lake'),
      infoWindow: InfoWindow(title: 'This is a lake'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.67645, 12.17477));

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
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Maps'),
        backgroundColor: Colors.amberAccent[400],
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
          crawlCard(),
          crawlCard(),
          crawlCard(),
          crawlCard(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onClicked: onItemTapped,
      ),
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

  Widget crawlCard() {
    return ListTile(
      leading: IconButton(
          onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
      title: Text('Crawl 1'),
      trailing: IconButton(
        icon: Icon(Icons.info),
        onPressed: () {},
      ),
    );
  }
}
