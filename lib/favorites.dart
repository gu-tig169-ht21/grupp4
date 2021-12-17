import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:english_words/english_words.dart';
import 'crawl_list_view.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int _selectedIndex = 0;
  final _randomWordPairs = <WordPair>[];
  final _addWordPairs = Set<WordPair>();

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.favorite), onPressed: _pushadd)
        ],
        backgroundColor: Colors.amberAccent[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: /*<Widget>*/ [
            _buildList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onClicked: onItemTapped,
      ),
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

  Widget _buildList() {
    return ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isEven) return Divider();

        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(2));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadyadd = _addWordPairs.contains(pair);

    // word-pair tile
    return ListTile(
        title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(alreadyadd ? Icons.check : Icons.add,
            color: alreadyadd ? Colors.green : null),
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
            appBar: AppBar(title: Text('Saved Word-Pairs')),
            body: ListView(children: divided));
      }));
}
