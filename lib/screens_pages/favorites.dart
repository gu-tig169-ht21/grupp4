// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import '../models/pub_crawl_model.dart';
import '../cat/interface_theme.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  var currentUser = FirebaseAuth.instance.currentUser!.email;
  var collection = FirebaseFirestore.instance.collection('User');
  Stream<QuerySnapshot> favorites =
      FirebaseFirestore.instance.collection('User').snapshots();
  List<Pub> favPubs = [];

  static List<String> favourites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        actions: const <Widget>[
          //IconButton(icon: Icon(Icons.favorite), onPressed: _pushadd)
        ],
        backgroundColor: ColorTheme.a,
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
/*
  Widget _buildRow(WordPair pair) {
    final alreadyadd = _addWordPairs.contains(pair);
    // word-pair tile
    return ListTile(
        title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(alreadyadd ? Icons.favorite : Icons.favorite,
            color: alreadyadd ? Colors.amber : null),
        onTap: () {
          setState(() {
            if (alreadyadd) {
              _addWordPairs.remove(pair);
            } else {
              _addWordPairs.add(pair);
            }
          });
        });
  }
  void _pushadd() => Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _addWordPairs.map((WordPair pair) {
          return ListTile(
              title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16.0)));
        });
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: tiles).toList();
        // saved word-pair page
        return Scaffold(
            appBar: AppBar(
              title: Text('Sparade favorjet barer'),
              backgroundColor: Colors.amberAccent[400],
            ),
            body: ListView(children: divided));
      }));
}
*/