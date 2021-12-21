import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../admin_navigation/crawl_list_view.dart';
import '../models/pub_crawl_model.dart';
import '../cat/interface_theme.dart';
import '../models/pub_crawl_model.dart';

class Favorites extends StatefulWidget {
  final PubCrawlModel favoriteCrawlModel;
  
  Favorites({required this.favoriteCrawlModel});

  @override
  State<Favorites> createState() => _FavoritesState(favoriteCrawlModel: favoriteCrawlModel);
}

class _FavoritesState extends State<Favorites> {
/*
  int _selectedIndex = 0;
   void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/
  final PubCrawlModel favoriteCrawlModel;
  
  //final List<Pub> pubList = favoriteCrawlModel.pubs;
  _FavoritesState({required this.favoriteCrawlModel});

 

  @override
  Widget build(BuildContext context) {
    final List<Pub> pubList = favoriteCrawlModel.pubs;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.favorite), onPressed: _pushadd)
        ],
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: /*<Widget>*/ [
            crawlCard(Pub(pubID: "1", name: "test", adress: "adress")),
            crawlCard(Pub(pubID: "1", name: "test", adress: "adress")),
            crawlCard(Pub(pubID: "1", name: "test", adress: "adress")),
            StatefulBuilder(
            builder: (Context, setState) =>
                Column(children: pubList.map((fpub) => crawlCard(fpub)).toList()),
          ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onClicked: onItemTapped,
      // ),
    );
  }

/*
Widget _buildLis() {
  return ListView.builder(
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(title: Text('favo bar'));
    },
  );
}*/

  Widget crawlCard(Pub pubs) {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          child: ListTile(
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
            title: Text(pubs.pubname),
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
          ),
        ),
      ],
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