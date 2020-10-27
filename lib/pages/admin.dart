import 'package:ammaratef45Flutter/custom_widgets/admin/blog_admin.dart';
import 'package:ammaratef45Flutter/custom_widgets/admin/projects_admin.dart';
import 'package:ammaratef45Flutter/pages/add_article.dart';
import 'package:ammaratef45Flutter/pages/add_project.dart';
import 'package:ammaratef45Flutter/pages/login.dart';
import 'package:ammaratef45Flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  static const String ROUTE = 'admin';
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<Widget> widgets = [
    ProjectsAdmin(),
    BlogAdmin(),
  ];

  int _selectedIndex = 0;
  final AuthService authService = AuthService.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!authService.isLogged()) {
      Navigator.pushReplacementNamed(context, LoginPage.ROUTE);
    }
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Blog',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        appBar: AppBar(),
        body: widgets[_selectedIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            switch (_selectedIndex) {
              case 0:
                Navigator.pushNamed(context, AddProjectPage.ROUTE);
                break;
              case 1:
                Navigator.pushNamed(context, AddArticlePage.ROUTE);
                break;
            }
          },
          icon: Icon(Icons.add),
          label: Text('Add'),
        ),
      ),
    );
  }
}
