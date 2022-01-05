import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/models/pub_crawl_model.dart';
import 'package:my_first_app/screens_pages/add_bar_screen.dart';
import 'register_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin_navigation/crawl_list_view.dart';
import '../firebase/Authenticate/authenticate.dart';
import '../cat/interface_theme.dart';

bool showLogout = false;

class newCrawl extends StatefulWidget {
  @override
  State<newCrawl> createState() => _newCrawlState();
}

class _newCrawlState extends State<newCrawl> {
  String crawlTitleLabel = 'Crawl Title';
  Color crawlTitleLabelColor = Colors.grey;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _crawlTitle = TextEditingController();
  final TextEditingController _crawlDesc = TextEditingController();
  final TextEditingController _crawlPubs = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color hintTextColor = Colors.grey.shade700;
    List<Pub> _pubs = [
      Pub(name: "Brygghuset", adress: 'Järntorget 4', isfavourite: false),
      Pub(name: "Steampunk Bar", adress: 'Kungsgatan 7A', isfavourite: false)
    ];
    Pub? _selectedBar;
    bool loggedIn;
    print('Current User: ' + FirebaseAuth.instance.currentUser.toString());
    if (FirebaseAuth.instance.currentUser == null) {
      print('inte inloggad');
      loggedIn = false;
    } else {
      loggedIn = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Crawl'),
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const Text('Please fill out all information below:'),
                  TextField(
                    controller: _crawlTitle,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: crawlTitleLabelColor),
                        labelText: crawlTitleLabel,
                        border: OutlineInputBorder()),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _crawlDesc,
                  decoration: InputDecoration(
                      label: Text(
                        'Description:',
                        style: TextStyle(color: hintTextColor),
                      ),
                      border: const OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _crawlPubs,
                  decoration: InputDecoration(
                      label: Text(
                        'Pubs: Separate with ";," between pubs',
                        style: TextStyle(color: hintTextColor),
                      ),
                      border: const OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                          (MaterialPageRoute(
                              builder: (context) => AddBarMap()))),
                      child: Text('Select bars'),
                    ),
                    DropdownButton<Pub>(
                      onChanged: (value) {
                        _selectedBar = value;
                      },
                      value: _selectedBar,
                      items: _pubs
                          .map((e) => DropdownMenuItem(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e.pubname,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                value: e,
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context, _crawlTitle.text);
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xffFDCF09)),
                    child: _photo != null
                        ? ClipRRect(
                            //borderRadius: BorderRadius.square(50),
                            child: Image.file(
                              _photo!,
                              width: size.width * 0.8,
                              height: size.height * 0.25,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            width: 300,
                            height: 150,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ),
              Visibility(
                visible: loggedIn,
                child: ElevatedButton(
                    child: const Text(
                      'Post you new Crawl!',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xffD9B250),
                    ),
                    onPressed: () async {
                      if (_crawlTitle.text.isEmpty) {
                        setState(() {
                          crawlTitleLabel = '*CrawlTitle is required';
                          crawlTitleLabelColor = Colors.red;
                        });
                        print('Label: ' + crawlTitleLabel);
                      } else {
                        createPubCrawl(
                            _crawlTitle.text, _crawlDesc.text, _crawlPubs.text);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(context, String crawlName) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery(crawlName);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera(crawlName);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future imgFromGallery(String crawlTitle) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        FirebaseApi().uploadFile(_photo, crawlTitle);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(String crawltitle) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        FirebaseApi().uploadFile(_photo, crawltitle);
      } else {
        print('No image selected.');
      }
    });
  }

  static void createPubCrawl(
      String crawltitle, String crawldescription, String crawlpubs) {
    String f = '"';

    FirebaseApi.postCrawl(PubCrawlModel(
        crawlID: f + crawltitle + f,
        title: f + crawltitle + f,
        description: f + crawldescription + f,
        pubs: f + crawlpubs + f,
        imgRef: f + crawltitle + f));
  }
}
