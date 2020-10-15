import 'package:ammaratef45Flutter/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';

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
    TextEditingController _controller = TextEditingController();
    _controller.text = project.description;
    MarkDownEditor _editor = MarkDownEditor(
      controller: _controller,
    );
    return Container(
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
                child: InkWell(
                  onTap: onClick,
                  child: Image.network(
                    project.image,
                    fit: BoxFit.cover,
                  ),
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
              child: _editor.preview,
            ),
          ],
        ),
      ),
    );
  }
}
