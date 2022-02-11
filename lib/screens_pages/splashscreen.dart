// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:provider/provider.dart';
import '../cat/state.dart';
import '../firebase/storage/firebase_file.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavbarPage())));
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<MyState>(context, listen: false);
    state
        .getCrawlList(); //Tänker att här laddar man in listan från Firebase under tiden som splaschscreen visas
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Image.asset('assets/images/splashscreen.jpg',
                fit: BoxFit.cover))
      ],
    );
  }
}
