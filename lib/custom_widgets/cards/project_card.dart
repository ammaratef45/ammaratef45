import 'package:ammaratef45Flutter/custom_widgets/cards/card.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function onClick;
  const ProjectCard({
    Key key,
    this.project,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      imageUrl: project.image,
      title: project.name,
      previewText: project.description,
      onClick: onClick,
    );
  }
}
