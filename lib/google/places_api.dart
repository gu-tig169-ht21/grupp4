import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; //namespace
import 'dart:convert';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:google_maps_webservice/places.dart';

var nyckel = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';
const apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=';

class Api {
  //todo, skapa variabel som tar emot adress

  static Future<Marker> getPlace(String place) async {
    String corrPlace = place;
    var response =
        await http.get(Uri.parse('$apiUrl/$place%Pub%Gothenburg&key=$nyckel'));
    String bodyString = response.body;
    var json = jsonDecode(bodyString);

    double lat = json['results'][0]['geometry']['location']['lat'];
    double lng = json['results'][0]['geometry']['location']['lng'];

    if (place.contains('%20')) {
      corrPlace = place.replaceAll(RegExp(r'%20'), ' ');
    }
    return Marker(
        markerId: MarkerId(place),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: corrPlace));
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

  Future<String> getCurrentCity() async {
    bool isLoading = false;
    List<PlacesSearchResult> places = [];
    String city;
    Position userPosition = await determinePosition();
    Location userCoord =
        Location(lat: userPosition.latitude, lng: userPosition.longitude);

    const kGoogleApiKey = 'AIzaSyCuPHW1WY319HfTCohnUXfBc7zMwVfgbmk';

    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    String? nextPageToken;

    final result = await _places.searchNearbyWithRadius(userCoord, 10000,
        type: 'postal_town');

    isLoading = true;
    if (result.status == 'OK') {
      nextPageToken = result.nextPageToken;
      places = result.results;
      for (var pub in result.results) {
        print(pub);
      }
    }
    return city = "1";
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
