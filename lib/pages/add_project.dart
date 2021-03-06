import 'package:ammaratef45Flutter/custom_widgets/admin/title_image_md.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/services/project_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddProjectPage extends StatelessWidget {
  static const String ROUTE = 'addProject';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ProjectsService projectsService = ProjectsService.instance;
  TitleImageMD inputs;

  AddProjectPage() {
    inputs = TitleImageMD(
      mdController: _descController,
      nameController: _nameController,
      imageController: _imageController,
    );
  }

  Future<void> _saveTheProject(Project project) async {
    project = Project.fromDoc(
      project?.id ?? '',
      {
        Project.NAME_KEY: _nameController.text,
        Project.DESC_KEY: _descController.text,
        Project.IMAGE_KEY: _imageController.text,
      },
    );
    project = await projectsService.addProject(project);
    if (inputs.shouldFinish()) {
      await inputs.finish('projects/${project.id}.png');
      print(_imageController.text + 'hwo');
      project = project.copyWithImage(_imageController.text);
      print(project.image);
      await projectsService.addProject(project);
    }
  }

  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context).settings.arguments;

    if (project != null) {
      _nameController.text = project.name;
      _descController.text = project.description;
      _imageController.text = project.image;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: inputs,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _saveTheProject(project).then((value) {
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
