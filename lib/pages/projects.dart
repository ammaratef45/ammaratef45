import 'package:ammaratef45Flutter/custom_widgets/error.dart';
import 'package:ammaratef45Flutter/custom_widgets/loading.dart';
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

// TODO move this to its own file
class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({
    Key key,
    this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      width: 400,
      child: Card(
        color: Theme.of(context).accentColor,
        elevation: 14,
        margin: EdgeInsets.all(2),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                child: Image.network(
                  project.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(6),
                color: Colors.white,
                child: Center(
                  child: SelectableText(
                    project.name,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.green,
                child: Center(
                  child: SelectableText(
                    project.description,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
