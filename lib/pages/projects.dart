import 'package:ammaratef45Flutter/models/project.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const String ROUTE = 'projects';
  Future<List<Project>> projects;

  ProjectsPage() {
    // TODO get these using a service from a firebase database
    projects = Future.delayed(
        Duration(seconds: 3),
        () => [
              Project('P1', 'Desc',
                  'https://www.xda-developers.com/files/2020/06/new-google-photos-logo.jpg'),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Project>>(
          future: projects,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text(snapshot.error.toString());
            if (!snapshot.hasData) return Text('laoding');
            return Wrap(
              children: [
                ...snapshot.data
                    .map(
                      (project) => ProjectCard(project: project),
                    )
                    .toList()
              ],
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
      height: 400,
      width: 400,
      child: Card(
        color: Theme.of(context).accentColor,
        elevation: 14,
        margin: EdgeInsets.all(2),
        child: Column(
          children: [
            Expanded(
              flex: 3,
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
                  child: Text(
                    project.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.share),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
