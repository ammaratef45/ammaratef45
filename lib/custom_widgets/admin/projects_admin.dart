import 'package:ammaratef45Flutter/custom_widgets/streams/projects_stream.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/pages/add_project.dart';
import 'package:flutter/material.dart';

class ProjectsAdmin extends StatelessWidget {
  const ProjectsAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProjectsStream(
      onClick: (Project project) {
        Navigator.pushNamed(context, AddProjectPage.ROUTE, arguments: project);
      },
    );
  }
}
