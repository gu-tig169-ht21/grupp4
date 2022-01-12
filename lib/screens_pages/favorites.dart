// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import '../cat/interface_theme.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  var currentUser = FirebaseAuth.instance.currentUser!.email;
  var collection = FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        actions: const <Widget>[],
        backgroundColor: ColorTheme.a,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          favorietList(),
        ],
      ),
    );
  }

  Widget favorietList() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: collection.doc(currentUser).snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var output = snapshot.data!.data();
          List<dynamic> value = output!['favoriets'];
          List<Widget> favList = [];
          for (int i = 0; i < value.length; i++) {
            favList.add(crawlCard(value[i]));
          }
          return (ListView(
            children: favList,
            shrinkWrap: true,
          ));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget crawlCard(value) {
    String f = value;
    String barnameB4 = value.toString();
    if (barnameB4.contains('%20')) {
      f = barnameB4.replaceAll(RegExp(r'%20'), ' ');
    }
    return Card(
      child: ListTile(
        title: Text(f),
        trailing: IconButton(
            onPressed: () {
              FirebaseApi.updateFavourite(value);
            },
            icon: const Icon(Icons.delete)),
      ),
    );
  }
}
