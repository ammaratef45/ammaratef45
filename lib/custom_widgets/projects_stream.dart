import 'package:ammaratef45Flutter/custom_widgets/error.dart';
import 'package:ammaratef45Flutter/custom_widgets/loading.dart';
import 'package:ammaratef45Flutter/custom_widgets/project_card.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/services/project_service.dart';
import 'package:flutter/material.dart';

class ProjectsStream extends StatelessWidget {
  final ProjectsService projectsService = ProjectsService.instance;
  final Function onClick;

  ProjectsStream({Key key, this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Project>>(
        stream: projectsService.getProjectsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return ErrorView(error: snapshot.error.toString());
          if (!snapshot.hasData) return LoadingView();
          return SingleChildScrollView(
            child: Center(
              child: Wrap(
                children: [
                  ...snapshot.data
                      .map(
                        (project) => ProjectCard(
                          project: project,
                          onClick: onClick == null
                              ? null
                              : () {
                                  Function.apply(onClick, [project]);
                                },
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          );
        });
  }
}
