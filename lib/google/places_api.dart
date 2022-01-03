import 'package:location/location.dart' as l;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; //namespace
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';

var nyckel = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';
const API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';

class Api {
  //todo, skapa variabel som tar emot adress

  static Future<Marker> callGetPlace(String place) {
    Future<Marker> marker = getPlace(place);
    return marker;
  }

  static Future<Marker> getPlace(String place) async {
    var response = await http.get(Uri.parse('$API_URL/$place&key=$nyckel'));
    String bodyString = response.body;
    var json = jsonDecode(bodyString);
    //print(json.toString());
    // Map<String, dynamic> map = jsonDecode(bodyString);
    double lat = json['results'][0]['geometry']['location']['lat'];
    double lng = json['results'][0]['geometry']['location']['lng'];
    //String coordinates = lat += ';,' + lng;

    return Marker(markerId: MarkerId(place), position: LatLng(lat, lng));
  }

  static Future<List<Marker>> callAllPlaces(String place) {
    Future<List<Marker>> allMarkers = getAllPlaces(place);
    return allMarkers;
  }

  static Future<List<Marker>> getAllPlaces(String place) async {
    List<Marker> markerList = [];
    List<String> allPlaces = place.split(';,');
    for (int i = 0; i < allPlaces.length; i++) {
      var response = await http
          .get(Uri.parse('$API_URL/' + allPlaces[i] + '&key=$nyckel'));
      String bodyString = response.body;
      var json = jsonDecode(bodyString);
      double lat = json['results'][0]['geometry']['location']['lat'];
      double lng = json['results'][0]['geometry']['location']['lng'];
      markerList.add(Marker(
        markerId: MarkerId(place[i]),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lng),
      ));
    }

    return markerList;
  }

  static Future<Pub> callGetPubInfo(String place) {
    Future<Pub> pub = getPubInfo(place);
    return pub;
  }

  static Future<Pub> getPubInfo(String pubNames) async {
    print('I GET PUB INFO');
    List<String> allPlaces = pubNames.split(';,');
    Pub pubInfo;
    String name = '';
    String adress = '';
    bool isfavourite = false;
    for (int i = 0; i < pubNames.length; i++) {
      var response = await http
          .get(Uri.parse('$API_URL/ ' + allPlaces[i] + '&key=$nyckel'));
      String bodyString = response.body;
      var json = jsonDecode(bodyString);
      print(json.toString());
      adress = json['results'][0]['formatted_address'];
      name = allPlaces[i];
      print('TITTA HÄÄÄR:' + name + '  ' + adress);
    }
    return Pub(name: name, adress: adress, isfavourite: isfavourite);
  }
}
