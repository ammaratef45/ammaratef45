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
      body: Center(
        child: Text('data'),
      ),
    );
  }
}
