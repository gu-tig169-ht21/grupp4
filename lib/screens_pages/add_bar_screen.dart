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

class AddBarMap extends StatefulWidget {
  @override
  State<AddBarMap> createState() => AddBarMapState();
}

class AddBarMapState extends State<AddBarMap> {
  //Måste göra en metod av det hela istället för att initiera allt i "initalizern"

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
          Container(
            height: 275,
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {},
              initialCameraPosition: _CenterGbg,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

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
}
