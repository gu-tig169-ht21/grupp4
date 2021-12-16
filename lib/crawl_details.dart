import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase/storage/firebase_file.dart';
import 'bottom_nav_bar.dart';
import 'firebase/storage/storage_services.dart';

class CrawlDetails extends StatefulWidget {
  @override
  State<CrawlDetails> createState() => _CrawlDetailsState();
}

class _CrawlDetailsState extends State<CrawlDetails> {
  late Future<List<FirebaseFile>> futureFiles;

  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('/');
  }

  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('View crawls'),
          centerTitle: true,
          backgroundColor: Colors.amberAccent[400],
        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  print(snapshot.toString());
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];

                            return buildFile(context, file);
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onClicked: onItemTapped,
        ),
      );

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () {},
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
}
