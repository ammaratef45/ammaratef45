import 'package:flutter/material.dart';

class SliverBar extends StatelessWidget {
  final Function onLogout;
  final Widget background;
  final String title;
  final Function onSave;

  const SliverBar(
      {Key key,
      this.onLogout,
      this.background,
      @required this.title,
      this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        background: background,
      ),
      actions: [
        if (onLogout != null)
          Padding(
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: onLogout,
            ),
            padding: EdgeInsets.only(right: 3),
          ),
        if (onSave != null)
          Padding(
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: onSave,
            ),
            padding: EdgeInsets.only(right: 3),
          ),
      ],
    );
  }
}
