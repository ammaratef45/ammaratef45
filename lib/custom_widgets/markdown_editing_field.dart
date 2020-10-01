import 'package:flutter/material.dart';

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
