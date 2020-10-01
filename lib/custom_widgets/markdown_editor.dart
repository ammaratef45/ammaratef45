import 'package:ammaratef45Flutter/custom_widgets/editor_buttons.dart';
import 'package:ammaratef45Flutter/custom_widgets/markdown_editing_field.dart';
import 'package:ammaratef45Flutter/custom_widgets/markdown_preview.dart';
import 'package:flutter/material.dart';

class MarkDownEditor extends StatefulWidget {
  @override
  _MarkDownEditorState createState() => _MarkDownEditorState();
}

class _MarkDownEditorState extends State<MarkDownEditor> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MrkdownEditingField(
          textController: _textController,
          onChange: () {
            setState(() {});
          },
        ),
        MarkdownEditorButtons(
          textEditingController: _textController,
          afterEditing: () {
            setState(
              () {},
            );
          },
        ),
        Flexible(
          child: MarkdownPreview(text: _textController.text),
        ),
      ],
    );
  }
}
