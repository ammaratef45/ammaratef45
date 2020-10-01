import 'package:ammaratef45Flutter/custom_widgets/editor_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

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

// TODO take these widgets in seperate files
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  // TODO add emoji selector to the editor
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Markdown(
          controller: ScrollController(),
          data: text,
          shrinkWrap: true,
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            [
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
        ),
      ),
    );
  }
}

class MrkdownEditingField extends StatelessWidget {
  const MrkdownEditingField({
    Key key,
    @required TextEditingController textController,
    this.onChange,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      maxLines: 8,
      controller: _textController,
      onChanged: (string) {
        onChange();
      },
    );
  }
}
