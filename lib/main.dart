import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'crawl_list_view.dart';
import 'firebase/Authenticate/authenticate.dart';
import './google/places_api.dart';
import 'navbar_page.dart';
import 'interface_theme.dart';
import 'firebase/storage/storage_services.dart';

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
      child: MaterialApp(
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
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String coordinates = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupp 4'),
        backgroundColor: ColorTheme.a,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splashscreen'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: ColorTheme.b),
              child: Text('navbar'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NavbarPage())),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: ColorTheme.b),
              child: Text('(till crawl screen)'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CrawlView())),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: ColorTheme.b),
              child: Text('(getPlace)'),
              onPressed: () async {
                coordinates = await Api.getPlace('Henriksberg');
                print('Detta är kordinaterna för Henriksberg: ' + coordinates);
              },
            ),
          ],
        ),
      ),
    );
  }
}
