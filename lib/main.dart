import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';
import 'crawl_list_view.dart';
import 'firebase/Authenticate/authenticate.dart';
import './google/places_api.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupp 4'),
        backgroundColor: Colors.amberAccent[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splashscreen'),
            ElevatedButton(
              child: Text('(till crawl screen)'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CrawlView())),
            ),
            ElevatedButton(
              child: Text('(getPlace)'),
              onPressed: () => Api.getPlace(),
            ),
          ],
        ),
      ),
    );
  }
}
