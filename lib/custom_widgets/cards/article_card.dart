import 'package:ammaratef45Flutter/custom_widgets/cards/card.dart';
import 'package:ammaratef45Flutter/models/article.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final Function onClick;

  const ArticleCard({
    Key key,
    @required this.article,
    this.onClick,
  })  : assert(article != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      imageUrl: article.image,
      title: article.name,
      previewText: article.content,
      onClick: onClick,
    );
  }
}
