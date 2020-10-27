import 'package:ammaratef45Flutter/custom_widgets/admin/image_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';

// ignore: must_be_immutable
class TitleImageMD extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController imageController;
  final TextEditingController mdController;

  TitleImageMD({
    Key key,
    @required this.nameController,
    @required this.imageController,
    @required this.mdController,
  }) : super(key: key) {
    imageInput = ImagePrompt(
      controller: imageController,
    );
  }

  ImagePrompt imageInput;

  bool shouldFinish() {
    return imageInput.shouldFinish();
  }

  Future<void> finish(String path) async {
    if (imageInput.shouldFinish()) {
      await imageInput.finish(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    MarkDownEditor _markDownEditor = MarkDownEditor(controller: mdController);
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
        ),
        imageInput,
        Expanded(child: _markDownEditor.inPlace()),
      ],
    );
  }
}
