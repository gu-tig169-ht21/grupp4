import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/cat/interface_theme.dart';
import 'package:my_first_app/cat/navbar_page.dart';
import 'package:my_first_app/firebase/Authenticate/authenticate.dart';
import 'package:my_first_app/firebase/storage/storage_services.dart';
import 'package:my_first_app/screens_pages/login_screen.dart';
import 'package:my_first_app/screens_pages/register_user.dart';
import 'package:provider/src/provider.dart';

import 'not_signed_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String admin = FirebaseApi.isAdmin().toString();
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Widget build(BuildContext context) {
    final TextEditingController _imageTitle = TextEditingController();
    Size size = MediaQuery.of(context).size;

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
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: ColorTheme.a,
                    borderRadius: new BorderRadius.vertical(
                      bottom: const Radius.elliptical(450, 60),
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
                  child: Container(
                    // width: 160,
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
                ),
              ],
            ),
            Container(
              height: 50,
            ),
            ElevatedButton(
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
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
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
            ),
            Container(
              height: 20,
            ),
          ],
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
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 75,
                        ),
                        Stack(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 155,
                              color: ColorTheme.f,
                            ),
                            const ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 13, top: 10),
                                child: const Icon(
                                  Icons.person,
                                  size: 130,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    final url = snapshot.data.toString();

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Image.network(
                            url,
                            fit: BoxFit.fill,
                            height: 130,
                            width: 130,
                          ),
                        ),
                      ],
                    );
                  }
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
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(String imageTitle) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        imageTitle = FirebaseAuth.instance.currentUser!.email.toString();
        FirebaseApi().uploadProfileImage(_photo, imageTitle);
      } else {
        print('No image selected.');
      }
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
