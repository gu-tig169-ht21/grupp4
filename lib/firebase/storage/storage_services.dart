import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firebase_file.dart';

class Storage {}

class FirebaseApi {
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> loadCrawlImage(String ref) async {
    final reference =
        await storage.ref('/crawlPics/PubImages/$ref').getDownloadURL();
    return reference;
    /* print(reference.toString() + '<-- detta är reference');
    var url = await reference.getDownloadURL();
    print('Detta är URL:en -->' + url.toString());
    return url; */
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future? storeUser() {
    try {
      FirebaseFirestore.instance.collection('User').add({
        'email': FirebaseAuth.instance.currentUser!.email,
        'Uid': FirebaseAuth.instance.currentUser!.uid,
        'favorites': ''
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future? regNewUser(email) async {
    try {
      await FirebaseFirestore.instance.collection('User').doc(email).set({
        'email': email,
        'Uid': FirebaseAuth.instance.currentUser!.uid,
        'favoriets': ''
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static void updateFavorites(String fav) async {
    print('detta är baren vi vill uppdatera: ' + fav);
    FirebaseFirestore.instance
        .collection('User')
        .doc(await FirebaseAuth.instance.currentUser!.email)
        .update({'favoriets': fav});
  }

  static Future<List<PubCrawlModel>> getCrawl() {
    Future<List<PubCrawlModel>> allCrawls = receiveCrawls();
    return allCrawls;
  }

  static Future<List<PubCrawlModel>> receiveCrawls() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('PubCrawls3').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var json = jsonDecode(allData.toString());
    List<PubCrawlModel> list = [];
    for (var crawls in json) {
      list.add(PubCrawlModel(
          crawlID: crawls['crawlID'],
          title: crawls['crawlTitle'],
          description: crawls['crawlDescription'],
          pubs: crawls['crawlPubs'],
          imgRef: crawls['crawlImgRef']));
    }
    /* list.add(PubCrawlModel(
        crawlID: json[0]['crawlID'],
        title: json[0]['crawlTitle'],
        description: json[0]['crawlDescription'],
        pubs: json[0]['crawlPubs']));
    list.add(PubCrawlModel(
        crawlID: json[1]['crawlID'],
        title: json[1]['crawlTitle'],
        description: json[1]['crawlDescription'],
        pubs: json[1]['crawlPubs'])); */
    return list;
  }

  Future uploadFile(dynamic _photo, String crawlName) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'PubImages/$crawlName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('/crawlPics/')
          .child(destination);
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  static void postCrawl(PubCrawlModel modelToUpload) async {
    FirebaseFirestore.instance
        .collection('PubCrawls3')
        .doc(modelToUpload.crawlID)
        .set({
      '"crawlTitle"': modelToUpload.crawlTitle,
      '"crawlID"': modelToUpload.crawlID,
      '"crawlDescription"': modelToUpload.crawlDescription,
      '"crawlPubs"': modelToUpload.crawlPubs,
      '"crawlImgRef"': modelToUpload.title
    });
  }

  static Future<bool> checkIfFavorite(String pubToRemove) async {
    String testbar = pubToRemove;
    String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    var collection = FirebaseFirestore.instance.collection('User');
    var docSnapshot = await collection.doc(userEmail).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      print(data.toString());
      List<dynamic> favourites = data?['favoriets'].toList();
      print(favourites);
      if (favourites.contains(pubToRemove)) {
        print('True! ' + pubToRemove + ' finns i listan och ska tas bort');
        removeFavourite(pubToRemove, favourites);
        return true;
      } else {
        String pubToAdd = pubToRemove;
        print('False! ' +
            pubToAdd +
            ' finns inte i listan och ska därför läggas till');
        addFavourite(pubToAdd, favourites);
        return false;
      }
    }
    return false;
  }

  static void removeFavourite(
      String pubToRemove, List<dynamic> favourites) async {
    String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    String Uid = FirebaseAuth.instance.currentUser!.uid.toString();
    favourites.remove(pubToRemove);
    FirebaseFirestore.instance
        .collection('User')
        .doc(userEmail)
        .set({"uid": Uid, "email": userEmail, "favoriets": favourites});
  }

  static void addFavourite(String pubToAdd, List<dynamic> favourites) async {
    String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    String Uid = FirebaseAuth.instance.currentUser!.uid.toString();
    favourites.add(pubToAdd);
    FirebaseFirestore.instance
        .collection('User')
        .doc(userEmail)
        .set({"uid": Uid, "email": userEmail, "favoriets": favourites});
  }
}
