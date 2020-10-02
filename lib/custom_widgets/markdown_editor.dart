import 'package:ammaratef45Flutter/custom_widgets/editor_buttons.dart';
import 'package:ammaratef45Flutter/custom_widgets/markdown_editing_field.dart';
import 'package:ammaratef45Flutter/custom_widgets/markdown_preview.dart';
import 'package:flutter/material.dart';

class MarkDownEditor extends StatefulWidget {
  final TextEditingController controller;

  const MarkDownEditor({Key key, this.controller}) : super(key: key);
  @override
  _MarkDownEditorState createState() => _MarkDownEditorState(controller);
}

class _MarkDownEditorState extends State<MarkDownEditor> {
  final TextEditingController controller;

  _MarkDownEditorState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MrkdownEditingField(
          textController: controller,
          onChange: () {
            setState(() {});
          },
        ),
        MarkdownEditorButtons(
          textEditingController: controller,
          afterEditing: () {
            setState(
              () {},
            );
          },
        ),
        Flexible(
          child: MarkdownPreview(text: controller.text),
        ),
      ],
    );
  }
}
