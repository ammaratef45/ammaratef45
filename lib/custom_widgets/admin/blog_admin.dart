import 'package:ammaratef45Flutter/custom_widgets/streams/article_stream.dart';
import 'package:ammaratef45Flutter/models/article.dart';
import 'package:ammaratef45Flutter/pages/add_article.dart';
import 'package:flutter/material.dart';

class BlogAdmin extends StatelessWidget {
  const BlogAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticleStream(
      onClick: (Article article) {
        Navigator.pushNamed(
          context,
          AddArticlePage.ROUTE,
          arguments: article,
        );
      },
    );
  }
}
