// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import '../firebase/storage/firebase_file.dart';
import '../firebase/storage/storage_services.dart';

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

    futureFiles = FirebaseApi.listAll('/images/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorTheme.a,
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.toString());
                return const Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    splashscreenImage(files),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget splashscreenImage(files) {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final file = files[index];

          return Image.network(file.url, fit: BoxFit.fill);
        },
      ),
    );
  }
}
