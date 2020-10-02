import 'package:ammaratef45Flutter/custom_widgets/markdown_preview.dart';
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
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 800,
        width: 400,
        child: Card(
          color: Colors.grey,
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
              Flexible(
                flex: 4,
                child: MarkdownPreview(
                  text: project.description,
                ),
              ),
              // Expanded(
              //   flex: 4,
              //   child: Container(
              //     color: Colors.green,
              //     child: Center(
              //       child: SelectableText(
              //         project.description,
              //         style: TextStyle(
              //           fontSize: 22,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
