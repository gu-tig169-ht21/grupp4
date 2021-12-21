import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firebase_file.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
}

class FirebaseApi {
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

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
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

  static void updateFavorites() async {
    FirebaseFirestore.instance
        .collection('User')
        .doc(await FirebaseAuth.instance.currentUser!.email)
        .update({'favoriets': 'Steampunk, ' 'Brygghuset, ' 'Tacos & tequila'});
  }

  static Future<List<PubCrawlModel>> getCrawl() {
    Future<List<PubCrawlModel>> allCrawls = receiveCrawls();
    return allCrawls;
  }

  static Future<List<PubCrawlModel>> receiveCrawls() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pubCrawls2').get();
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
}
