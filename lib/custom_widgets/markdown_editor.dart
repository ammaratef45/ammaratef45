import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// TODO fix the layout
class MarkDownEditor extends StatefulWidget {
  @override
  _MarkDownEditorState createState() => _MarkDownEditorState();
}

class _MarkDownEditorState extends State<MarkDownEditor> {
  final _textController = TextEditingController();

  final _scrollbarController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  autofocus: true,
                  maxLines: 8,
                  controller: _textController,
                  onChanged: (string) {
                    setState(() {});
                  },
                ),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              Expanded(
                flex: 1,
                child: Markdown(
                  data: _textController.text ?? '',
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 64,
          child: Scrollbar(
            controller: _scrollbarController,
            isAlwaysShown: true,
            child: ListView(
              controller: _scrollbarController,
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  tooltip: 'Bold',
                  icon: Icon(Icons.format_bold),
                  onPressed: () => _surroundTextSelection(
                    '**',
                    '**',
                  ),
                ),
                IconButton(
                  tooltip: 'Underline',
                  icon: Icon(Icons.format_italic),
                  onPressed: () => _surroundTextSelection(
                    '__',
                    '__',
                  ),
                ),
                IconButton(
                  tooltip: 'Code',
                  icon: Icon(Icons.code),
                  onPressed: () => _surroundTextSelection(
                    '```',
                    '```',
                  ),
                ),
                IconButton(
                  tooltip: 'Strikethrough',
                  icon: Icon(Icons.strikethrough_s_rounded),
                  onPressed: () => _surroundTextSelection(
                    '~~',
                    '~~',
                  ),
                ),
                IconButton(
                  tooltip: 'Link',
                  icon: Icon(Icons.link_sharp),
                  onPressed: () => _surroundTextSelection(
                    '[',
                    '](https://)',
                  ),
                ),
                IconButton(
                  tooltip: 'Image',
                  icon: Icon(Icons.image),
                  onPressed: () => _surroundTextSelection(
                    '![',
                    '](https://)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _surroundTextSelection(String left, String right) {
    final currentTextValue = _textController.value.text;
    final selection = _textController.selection;
    final middle = selection.textInside(currentTextValue);
    final newTextValue = selection.textBefore(currentTextValue) +
        '$left$middle$right' +
        selection.textAfter(currentTextValue);

    _textController.value = _textController.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + left.length + middle.length,
      ),
    );
    setState(() {});
  }
}
