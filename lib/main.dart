import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/Authenticate/authenticate.dart';
import 'cat/navbar_page.dart';
import 'firebase/storage/storage_services.dart';
import 'screens_pages/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authstatechanges,
          initialData: 0,
        ),
      ],
      child: const MaterialApp(
        title: 'hej',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          children: [
            const Splashscreen(),
            Container(
              padding: const EdgeInsets.only(bottom: 100),
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                  child: const Text(
                    "Start",
                    textScaleFactor: 1.7,
                    style: TextStyle(),
                  ),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(170, 65),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color.fromRGBO(114, 107, 89, 1),
                        width: 7,
                      ),
                      primary: Colors.black),
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NavbarPage(),
                        ),
                      ),
                  onLongPress: () async {
                    //'Här finns ett utrymme för att testa funktioner!
                    bool x = await FirebaseApi.isAdmin();
                    if (x) {}
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
