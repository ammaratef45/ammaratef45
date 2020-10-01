import 'package:universal_html/prefer_universal/js.dart' as js;
import 'package:ammaratef45Flutter/custom_widgets/link_icon.dart';
import 'package:ammaratef45Flutter/models/myinfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeBody extends StatelessWidget {
  final MyInfo myInfo;
  const HomeBody({
    Key key,
    @required this.myInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            children: [
              SelectableText(
                'About me',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(myInfo.about),
            ],
          ),
        ),
        SizedBox(
          width: 40,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            children: [
              SelectableText(
                'Contact Me',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinkIcon(
                    iconData: FontAwesomeIcons.facebook,
                    color: Color(0xff3b5998),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['https://www.facebook.com/ammaratef45'],
                      );
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.twitter,
                    color: Color(0xff55acee),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['https://twitter.com/ammaratef45'],
                      );
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.linkedin,
                    color: Color(0xff007bb5),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['https://www.linkedin.com/in/ammaratef45/'],
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinkIcon(
                    iconData: FontAwesomeIcons.github,
                    color: Color(0xff000000),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['https://github.com/ammaratef45'],
                      );
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.instagram,
                    color: Color(0xff125688),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['https://www.instagram.com/ammar.atef45/'],
                      );
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.envelope,
                    color: Color(0xff865dae),
                    onPressed: () {
                      js.context.callMethod(
                        'open',
                        ['mailto:ammar.atef45@gmail.com'],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
