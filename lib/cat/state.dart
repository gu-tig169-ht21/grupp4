import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';

import '../google/places_api.dart';
import '../models/pub_crawl_model.dart';

class MyState extends ChangeNotifier {
  String? currentUser;
  String? currentUserLocation;
  List<Pub> userFavoriets = [];
  List<PubCrawlModel> _crawlsForCurrentCity = [];
  Position? _userPosition;

  List<PubCrawlModel> get crawlsForCurrentCity => _crawlsForCurrentCity;
  Position? get userPosition => _userPosition;
  void getUserName() {
    //TODO: skriv kod för att hämta användarnamn från Firebase (och lägg till användarnamn på Firebase)
  }

  void getUserLocation() async {
    _userPosition = await Api.determinePosition();
  }

  void getCrawlList() async {
    List<PubCrawlModel> crawlList = await FirebaseApi.receiveCrawls();
    _crawlsForCurrentCity = crawlList;
    notifyListeners();
  }
}
