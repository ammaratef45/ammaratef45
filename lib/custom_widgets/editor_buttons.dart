import 'package:flutter/material.dart';

class MarkdownEditorButtons extends StatelessWidget {
  final _scrollbarController = ScrollController();
  final TextEditingController textEditingController;
  final Function afterEditing;

  MarkdownEditorButtons(
      {Key key, @required this.textEditingController, this.afterEditing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }

  void _surroundTextSelection(String left, String right) {
    final currentTextValue = textEditingController.value.text;
    final selection = textEditingController.selection;
    final middle = selection.textInside(currentTextValue);
    final newTextValue = selection.textBefore(currentTextValue) +
        '$left$middle$right' +
        selection.textAfter(currentTextValue);

    textEditingController.value = textEditingController.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + left.length + middle.length,
      ),
    );
    if (afterEditing != null) afterEditing();
  }
}
