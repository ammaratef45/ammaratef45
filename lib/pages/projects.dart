import 'package:ammaratef45Flutter/custom_widgets/streams/projects_stream.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const String ROUTE = 'projects';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ProjectsStream(),
      ),
    );
  }
}
