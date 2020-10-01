import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;

  const ErrorView({Key key, @required this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SelectableText(
        error,
        style: TextStyle(
          color: Colors.red,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
