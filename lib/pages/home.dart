import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

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
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: Column(
                  children: [
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
                    Text('data'),
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

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      width: double.infinity,
      child: Column(
        children: [
          AvatarGlow(
            endRadius: 90,
            duration: Duration(seconds: 2),
            glowColor: Colors.white24,
            repeat: true,
            repeatPauseDuration: Duration(seconds: 2),
            startDelay: Duration(seconds: 1),
            child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset('assets/avatar.jpg'),
                  radius: 50.0,
                )),
          ),
          Text(
            'Ammar Hussein',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Software Engineer - Blogger - Vegan'),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    Key key,
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
          Text(
            'Ammar Hussein',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Text('Blog'),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {},
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
