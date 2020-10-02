import 'package:ammaratef45Flutter/custom_widgets/projects_stream.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/pages/add_project.dart';
import 'package:ammaratef45Flutter/pages/login.dart';
import 'package:ammaratef45Flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  static const String ROUTE = 'admin';
  final AuthService authService = AuthService.instance;
  @override
  Widget build(BuildContext context) {
    if (!authService.isLogged()) {
      Navigator.pushReplacementNamed(context, LoginPage.ROUTE);
    }
    return Scaffold(
      body: ProjectsStream(
        onClick: (Project p) {
          Navigator.pushNamed(context, AddProjectPage.ROUTE, arguments: p);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddProjectPage.ROUTE);
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
    );
  }
}
