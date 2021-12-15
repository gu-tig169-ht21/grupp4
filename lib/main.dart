import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/Authenticate/Authenticate.dart';
import 'package:provider/provider.dart';

import 'crawl_view.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupp 4'),
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
          ],
        ),
      ),
    );
  }
}
