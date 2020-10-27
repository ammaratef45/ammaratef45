import 'package:ammaratef45Flutter/custom_widgets/home/link_icon.dart';
import 'package:ammaratef45Flutter/models/myinfo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      const href = 'https://www.facebook.com/ammaratef45';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.twitter,
                    color: Color(0xff55acee),
                    onPressed: () {
                      const href = 'https://twitter.com/ammaratef45';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.linkedin,
                    color: Color(0xff007bb5),
                    onPressed: () {
                      const href = 'https://www.linkedin.com/in/ammaratef45/';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
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
                      const href = 'https://github.com/ammaratef45';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.instagram,
                    color: Color(0xff125688),
                    onPressed: () {
                      const href = 'https://www.instagram.com/ammar.atef45/';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
                    },
                  ),
                  LinkIcon(
                    iconData: FontAwesomeIcons.envelope,
                    color: Color(0xff865dae),
                    onPressed: () {
                      const href = 'mailto:ammar.atef45@gmail.com';
                      canLaunch(href).then((value) {
                        if (value) {
                          launch(href);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Couldn't open the URL",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
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
