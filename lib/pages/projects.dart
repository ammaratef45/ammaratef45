import 'package:ammaratef45Flutter/custom_widgets/projects_stream.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const String ROUTE = 'projects';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectsStream(),
    );
  }
}
