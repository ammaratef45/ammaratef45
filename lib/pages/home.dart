import 'dart:ui';
import 'dart:js' as js;
import 'package:ammaratef45Flutter/custom_widgets/header.dart';
import 'package:ammaratef45Flutter/custom_widgets/link_icon.dart';
import 'package:ammaratef45Flutter/custom_widgets/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MenuBar(),
          Header(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: Column(
                  children: [
                    // TODO get the info about me from a firebase database
                    Text(
                      'About me',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        'Software Engineering is what I do for living (and I do enjoy doing it), Check the projects tab if you want to get a look on some of my work. I write sometimes about my thoughts and ideas, you can check the blog tab. I love languages and culture differences, I try to do my part in protecting the environment. I believe in love and I have no reason to hate anyone.'),
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
                    Text(
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
          ),
        ],
      ),
    );
  }
}
