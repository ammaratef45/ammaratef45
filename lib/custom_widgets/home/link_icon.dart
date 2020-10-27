import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LinkIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final Function onPressed;
  const LinkIcon({
    Key key,
    @required this.iconData,
    @required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      child: IconButton(
        icon: FaIcon(
          iconData,
          size: 40,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
