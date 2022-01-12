import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';

class NoFavorites extends StatefulWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  State<NoFavorites> createState() => NoFavoritesState();
}

class NoFavoritesState extends State<NoFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: ColorTheme.a,
        shadowColor: ColorTheme.a,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            signinText(),
          ],
        ),
      ),
    );
  }

  Widget signinText() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Expanded(
        flex: 10,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: const Text(
            'You need to be signed in to save and view favourites.',
          ),
        ),
      ),
    );
  }
}
