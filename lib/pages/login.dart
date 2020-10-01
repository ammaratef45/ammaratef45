import 'package:ammaratef45Flutter/pages/admin.dart';
import 'package:ammaratef45Flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  final AuthService authService = AuthService.instance;
  static const String ROUTE = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            authService.signIn().then((value) {
              if (value) {
                Navigator.pushReplacementNamed(context, AdminPage.ROUTE);
              }
            });
          },
          child: Container(
            height: 60,
            width: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.white,
            ),
            child: Center(
              child: SelectableText(
                'Login with Google',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8185E2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
