// ignore_for_file: implementation_imports, unnecessary_null_comparison, use_key_in_widget_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:my_first_app/firebase/Authenticate/authenticate.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/screens_pages/login_screen.dart';
import 'package:my_first_app/screens_pages/new_crawl.dart';
import 'package:provider/src/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _imageTitle = TextEditingController();
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    isAdmin();
  }

  void isAdmin() async {
    showButton = await FirebaseApi().isAdmin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: ColorTheme.a,
        shadowColor: ColorTheme.a,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            profileArea(),
            Container(
              height: 50,
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            Visibility(
              visible: showButton,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewCrawl(),
                    ),
                  );
                },
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
                  child: Text(
                    'Create Crawl [ADMIN ONLY]',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: ColorTheme.b,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
            ),
            signoutButton(),
          ],
        ),
      ),
    );
  }

  Widget profileArea() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            color: ColorTheme.a,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.elliptical(450, 60),
            ),
          ),
        ),
        Positioned.fill(
          top: -50,
          left: 5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: profileCard(),
          ),
        ),
        Positioned.fill(
          top: 50,
          left: 80,
          child: GestureDetector(
            child: Align(
              alignment: Alignment.centerLeft,
              child: changeProfilePic(),
            ),
            onTap: () {
              _showPicker(context, _imageTitle.text);
            },
          ),
        ),
        Positioned.fill(
          left: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                'Hello',
                style: TextStyle(color: ColorTheme.f),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                email != null ? email.toString() : 'User',
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: Colors.black45,
                          offset: Offset.fromDirection(45, 3.0),
                          blurRadius: 10)
                    ],
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget signoutButton() {
    return ElevatedButton(
      onPressed: () async {
        await context.read<AuthenticationService>().signOut();
        /* if (FirebaseAuth.instance.currentUser == null) {
                  setState(() {});
                }*/
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NavbarPage(),
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
        child: Text(
          'Sign out',
          style: TextStyle(color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: ColorTheme.b,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget changeProfilePic() {
    return ClipOval(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Icon(
            Icons.circle,
            size: 40,
            color: ColorTheme.b,
          ),
          const IconButton(
              icon: Icon(Icons.camera_alt),
              iconSize: 20,
              color: Colors.black,
              onPressed: null),
        ],
      ),
    );
  }

  Widget profileCard() {
    bool x = false;
    if (FirebaseApi().checkIfProfilePic(email.toString())) {
      x = true;
    }
    return ClipOval(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          FutureBuilder(
            future: x
                ? getProfileImage(
                    FirebaseAuth.instance.currentUser!.email.toString())
                : getIcon(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  final url = snapshot.data.toString();
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          height: 130,
                          width: 130,
                        ),
                      ),
                    ],
                  );
              }
            },
          )
        ],
      ),
    );
  }

  Future<String> getProfileImage(String imageName) async {
    String path = await FirebaseApi().loadProfileImage(imageName);
    return path;
  }

  void _showPicker(context, String imageName) {
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
                    imgFromGallery(imageName);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  imgFromCamera(imageName);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future imgFromGallery(String imageTitle) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        imageTitle = FirebaseAuth.instance.currentUser!.email.toString();
        FirebaseApi().uploadProfileImage(_photo, imageTitle);
      } else {}
    });
  }

  Future imgFromCamera(String imageTitle) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        imageTitle = FirebaseAuth.instance.currentUser!.email.toString();
        FirebaseApi().uploadProfileImage(_photo, imageTitle);
      } else {}
    });
  }

  Future<Positioned> getIcon() async {
    return Positioned.fill(
      top: -50,
      left: 5,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.circle,
          size: 155,
          color: ColorTheme.f,
        ),
      ),
    );
  }
}
