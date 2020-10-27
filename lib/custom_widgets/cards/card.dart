import 'package:flutter/material.dart';
import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';

class MyCard extends StatelessWidget {
  final Function onClick;
  final String imageUrl;
  final String title;
  final String previewText;

  const MyCard({
    Key key,
    this.onClick,
    @required this.imageUrl,
    @required this.title,
    @required this.previewText,
  })  : assert(imageUrl != null),
        assert(title != null),
        assert(previewText != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    _controller.text = previewText;
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
                    imageUrl,
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
                    title,
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
