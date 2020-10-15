import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';

// TODO allow text select for preview
class AddProjectPage extends StatelessWidget {
  static const String ROUTE = 'addProject';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ProjectsService projectsService = ProjectsService.instance;
  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context).settings.arguments;
    MarkDownEditor _markDownEditor =
        MarkDownEditor(controller: _descController);
    if (project != null) {
      _nameController.text = project.name;
      _descController.text = project.description;
      _imageController.text = project.image;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Project Name',
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  hintText: 'Image',
                ),
              ),
            ),
            Expanded(child: _markDownEditor.inPlace()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            projectsService
                .addProject(
              Project.fromDoc(project?.id ?? '', {
                Project.NAME_KEY: _nameController.text,
                Project.DESC_KEY: _descController.text,
                Project.IMAGE_KEY: _imageController.text,
              }),
            )
                .then((value) {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
      ),
    );
  }
}
