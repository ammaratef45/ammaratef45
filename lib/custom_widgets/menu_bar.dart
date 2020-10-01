import 'package:ammaratef45Flutter/models/myinfo.dart';
import 'package:ammaratef45Flutter/pages/blog.dart';
import 'package:ammaratef45Flutter/pages/projects.dart';
import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  final MyInfo myInfo;
  const MenuBar({
    Key key,
    @required this.myInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          SelectableText(
            myInfo.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, BlogPage.ROUTE);
            },
            child: Text('Blog'),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProjectsPage.ROUTE);
            },
            child: Text('Projects'),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
