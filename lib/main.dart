import 'package:ammaratef45Flutter/custom_widgets/error.dart';
import 'package:ammaratef45Flutter/custom_widgets/loading.dart';
import 'package:ammaratef45Flutter/pages/add_project.dart';
import 'package:ammaratef45Flutter/pages/admin.dart';
import 'package:ammaratef45Flutter/pages/blog.dart';
import 'package:ammaratef45Flutter/pages/home.dart';
import 'package:ammaratef45Flutter/pages/login.dart';
import 'package:ammaratef45Flutter/pages/projects.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ammar Hussein',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(
        child: FutureBuilder<FirebaseApp>(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: ErrorView(
                    error: snapshot.error.toString(),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Scaffold(
                  body: LoadingView(),
                );
              }
              return HomePage();
            }),
      ),
      routes: {
        ProjectsPage.ROUTE: (context) => ProjectsPage(),
        AdminPage.ROUTE: (context) => AdminPage(),
        LoginPage.ROUTE: (context) => LoginPage(),
        BlogPage.ROUTE: (context) => BlogPage(),
        AddProjectPage.ROUTE: (context) => AddProjectPage(),
      },
    );
  }
}
