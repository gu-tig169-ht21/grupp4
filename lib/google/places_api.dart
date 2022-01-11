import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; //namespace
import 'dart:convert';
import 'package:my_first_app/models/pub_crawl_model.dart';

var nyckel = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';
const apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=';

class Api {
  //todo, skapa variabel som tar emot adress

  static Future<Marker> callGetPlace(String place) {
    Future<Marker> marker = getPlace(place);
    return marker;
  }

  static Future<Marker> getPlace(String place) async {
    String corrPlace = place;
    var response =
        await http.get(Uri.parse('$apiUrl/$place%Pub%Gothenburg&key=$nyckel'));
    String bodyString = response.body;
    var json = jsonDecode(bodyString);
    //print(json.toString());
    // Map<String, dynamic> map = jsonDecode(bodyString);

    double lat = json['results'][0]['geometry']['location']['lat'];
    double lng = json['results'][0]['geometry']['location']['lng'];

    //String coordinates = lat += ';,' + lng;
    if (place.contains('%20')) {
      corrPlace = place.replaceAll(RegExp(r'%20'), ' ');
    }
    return Marker(
        markerId: MarkerId(place),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: corrPlace));
  }

  static Future<List<Marker>> callAllPlaces(String place) {
    Future<List<Marker>> allMarkers = getAllPlaces(place);
    return allMarkers;
  }

  static Future<List<Marker>> getAllPlaces(String place) async {
    List<Marker> markerList = [];
    List<String> allPlaces = place.split(';,');
    for (int i = 0; i < allPlaces.length; i++) {
      var response = await http.get(
          Uri.parse('$apiUrl/' + allPlaces[i] + '%Pub%Gothenburg&key=$nyckel'));
      String bodyString = response.body;
      var json = jsonDecode(bodyString);
      if (json['results'][0]['status'] != null) {
        double lat = json['results'][0]['geometry']['location']['lat'];
        double lng = json['results'][0]['geometry']['location']['lng'];
        markerList.add(Marker(
          markerId: MarkerId(place[i]),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(lat, lng),
        ));
      }
    }

    return markerList;
  }

  static Future<List<LatLng>> reveiveCoordinates(List<String> places) async {
    List<LatLng> markerList = [];
    for (int i = 0; i < places.length; i++) {
      var response = await http.get(
          Uri.parse('$apiUrl/' + places[i] + '%Pub%Gothenburg&key=$nyckel'));
      String bodyString = response.body;

      var json = jsonDecode(bodyString);

      double lat = json['results'][0]['geometry']['location']['lat'];
      double lng = json['results'][0]['geometry']['location']['lng'];
      markerList.add(
        LatLng(lat, lng),
      );
    }
    return markerList;
  }

  static Future<Pub> callGetPubInfo(String place) {
    Future<Pub> pub = getPubInfo(place);
    return pub;
  }

  static Future<Pub> getPubInfo(String pubName) async {
    String name = '';
    String adress = '';
    bool isfavourite = false;
    var response = await http
        .get(Uri.parse('$apiUrl/ ' + pubName + '%Pub%Gothenburg&key=$nyckel'));
    String bodyString = response.body;
    var json = jsonDecode(bodyString);
    if (json['status'] == 'OK') {
      adress = json['results'][0]['formatted_address'];

      name = pubName;
    }
    return Pub(name: name, adress: adress, isfavourite: isfavourite);
  }
}
