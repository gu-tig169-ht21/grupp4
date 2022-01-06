import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import '../admin_navigation/crawl_list_view.dart';
import '../models/pub_crawl_model.dart';
import '../cat/interface_theme.dart';
import '../models/pub_crawl_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  int _selectedIndex = 0;
  final _pub = <Pub>[];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<String> favourites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.favorite), onPressed: _pushadd)
        ],
        backgroundColor: ColorTheme.a,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.doc(currentUser).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                List<dynamic> value = output!['favoriets'];
                List<Widget> favList = [];
                for (int i = 0; i < value.length; i++) {
                  print(value.length);
                  print(value[i]);

                  favList.add(crawlCard(value[i]));
                }
                return (ListView(
                  children: favList,
                  shrinkWrap: true,
                ));
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  Widget crawlCard(value) {
    String f = value;
    String barnameB4 = value.toString();
    if (barnameB4.contains('%20')) {
      f = barnameB4.replaceFirst(RegExp(r'%20'), ' ');
      print(f);
    }
    return Card(
      child: ListTile(
        title: Text(f),
        trailing: IconButton(
            onPressed: () {
              FirebaseApi.updateFavourite(value);
            },
            icon: Icon(Icons.delete)),
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