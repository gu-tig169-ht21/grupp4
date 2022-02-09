import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';

import '../models/pub_crawl_model.dart';

class MyState extends ChangeNotifier {
  String? currentUser;
  String? currentUserLocation;
  List<Pub> userFavoriets = [];
  List<PubCrawlModel> _crawlsForCurrentCity = [];

  List<PubCrawlModel> get crawlsForCurrentCity => _crawlsForCurrentCity;

  void getUserName() {
    //TODO: skriv kod för att hämta användarnamn från Firebase (och lägg till användarnamn på Firebase)
  }
  void getUserLocation() async {}

  void getCrawlList() async {
    List<PubCrawlModel> crawlList = await FirebaseApi.receiveCrawls();
    _crawlsForCurrentCity = crawlList;
    notifyListeners();
  }
}
