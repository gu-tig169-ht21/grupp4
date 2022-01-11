// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:google_maps_webservice/places.dart';

List<Marker> markerList = [];

class AddBarMap extends StatefulWidget {
  @override
  State<AddBarMap> createState() => AddBarMapState();
}

class AddBarMapState extends State<AddBarMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Pub> _pubsGbg = [];
  final List<Pub> _selectedPubs = [];
  List<PlacesSearchResult> places = [];
  bool isLoading = false;

  static final CameraPosition _centerGbg = CameraPosition(
    target: LatLng(57.70884963208789, 11.974438295782342),
    zoom: 12.50,
  );

  static final Marker henke = Marker(
      markerId: MarkerId('Henriksberg'),
      infoWindow: InfoWindow(title: 'Ta en bira eller 2!'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(57.699687182039845, 11.936588759846018));

  @override
  Widget build(BuildContext context) {
    int x = 0;
    Pub? selected;
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Google Maps'),
        backgroundColor: Color(0xffD9B250),
      ),
      body: Column(children: [
        Container(
          height: 275,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _centerGbg,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Color(0xffD9B250),
                      ),
                    ],
                  )
                : const Text(' '),
          ),
        ),
        DropdownButton<Pub>(
          onChanged: (value) {
            selected = value;
            setState(() {
              _selectedPubs.add(selected!);
            });
          },
          items: _pubsGbg
              .map((pub) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        pub.pubname,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    value: pub,
                  ))
              .toList(),
          onTap: () {},
        ),
        Visibility(
          visible: _pubsGbg.isEmpty,
          child: ElevatedButton(
            onPressed: getNearbyPlaces,
            child: Text('Ladda barer'),
          ),
        ),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: _choosenBars(_selectedPubs, context, x)),
          ),
        ),
      ]),
    );
  }

  Widget _choosenBars(List<Pub> _selectedPubs, context, int x) {
    return StatefulBuilder(
      builder: (context, setState) => Column(
          children:
              _selectedPubs.map((pub) => _oneBar(pub, context, x)).toList()),
    );
  }

  Widget _oneBar(Pub pub, context, int x) {
    return Card(
      child: InkWell(
        child: ListTile(
          leading: Text(x.toString()),
          title: Text(pub.pubname),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _selectedPubs.remove(pub);
              });
            },
            icon: const Icon(Icons.close),
          ),
        ),
      ),
    );
  }

  void getNearbyPlaces() async {
    const kGoogleApiKey = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    var nextPageToken;

    final location = Location(lat: 57.70884963208789, lng: 11.974438295782342);
    final result = await _places.searchNearbyWithRadius(location, 3500,
        type: 'bar', pagetoken: nextPageToken);
    setState(() {
      isLoading = true;
      if (result.status == 'OK') {
        nextPageToken = result.nextPageToken;
        places = result.results;
        for (var pub in result.results) {
          _pubsGbg.add(Pub(
              name: pub.name,
              adress: pub.formattedAddress.toString(),
              isfavourite: false));
        }
      }
    });
    new Future.delayed(Duration(seconds: 2), () async {
      final result2 = await _places.searchNearbyWithRadius(location, 3500,
          type: 'bar', pagetoken: nextPageToken);

      setState(() {
        if (result2.status == 'OK') {
          places = result2.results;
          nextPageToken = result2.nextPageToken;
          for (var pub2 in result2.results) {
            _pubsGbg.add(Pub(
                name: pub2.name,
                adress: pub2.formattedAddress.toString(),
                isfavourite: false));
          }
        }
      });

      new Future.delayed(Duration(seconds: 2), () async {
        final result3 = await _places.searchNearbyWithRadius(location, 3500,
            type: 'bar', pagetoken: nextPageToken);
        setState(() {
          if (result3.status == 'OK') {
            places = result3.results;
            for (var pub3 in result3.results) {
              _pubsGbg.add(Pub(
                  name: pub3.name,
                  adress: pub3.formattedAddress.toString(),
                  isfavourite: false));
            }
          }
          isLoading = false;
        });
      });
    });
  }
}
