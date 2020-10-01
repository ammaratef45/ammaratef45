import 'package:ammaratef45Flutter/pages/home.dart';
import 'package:ammaratef45Flutter/pages/projects.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<FirebaseApp>(
          future: _initialization,
          builder: (context, snapshot) {
            // TODO handle error and loading appropiately
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return Text('No data yet');
            }
            return HomePage();
          }),
      routes: {
        ProjectsPage.ROUTE: (context) => ProjectsPage(),
      },
    );
  }
}
