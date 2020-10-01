import 'package:ammaratef45Flutter/custom_widgets/error.dart';
import 'package:ammaratef45Flutter/custom_widgets/loading.dart';
import 'package:ammaratef45Flutter/custom_widgets/project_card.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/services/project_service.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const String ROUTE = 'projects';
  final ProjectsService projectsService = ProjectsService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Project>>(
          stream: projectsService.getProjectsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return ErrorView(error: snapshot.error.toString());
            if (!snapshot.hasData) return LoadingView();
            return SingleChildScrollView(
              child: Wrap(
                children: [
                  ...snapshot.data
                      .map(
                        (project) => ProjectCard(project: project),
                      )
                      .toList()
                ],
              ),
            );
          }),
    );
  }
}
