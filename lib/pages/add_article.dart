import 'package:ammaratef45Flutter/custom_widgets/admin/title_image_md.dart';
import 'package:ammaratef45Flutter/models/article.dart';
import 'package:ammaratef45Flutter/models/project.dart';
import 'package:ammaratef45Flutter/services/articles_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddArticlePage extends StatelessWidget {
  static const String ROUTE = 'addArticle';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ArticlesService articlesService = ArticlesService.instance;
  TitleImageMD inputs;

  AddArticlePage() {
    inputs = TitleImageMD(
      mdController: _descController,
      nameController: _nameController,
      imageController: _imageController,
    );
  }

  Future<void> _saveTheArticle(Article article) async {
    article = Article.fromDoc(
      article?.id ?? '',
      {
        Project.NAME_KEY: _nameController.text,
        Project.DESC_KEY: _descController.text,
        Project.IMAGE_KEY: _imageController.text,
      },
    );
    article = await articlesService.addArticle(article);
    if (inputs.shouldFinish()) {
      await inputs.finish('articles/${article.id}.png');
      article = article.copyWithImage(_imageController.text);
      await articlesService.addArticle(article);
    }
  }

  @override
  Widget build(BuildContext context) {
    Article article = ModalRoute.of(context).settings.arguments;

    if (article != null) {
      _nameController.text = article.name;
      _descController.text = article.content;
      _imageController.text = article.image;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: inputs,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _saveTheArticle(article).then((value) {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
      ),
    );
  }
}
