import 'package:ammaratef45Flutter/models/article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesService {
  static const String ARTICLES_COLLECTION = 'articles';
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ArticlesService._();
  static ArticlesService _instance;

  static ArticlesService get instance {
    if (_instance == null) {
      _instance = ArticlesService._();
    }
    return _instance;
  }

  Stream<List<Article>> getArticlesStream() async* {
    await for (final QuerySnapshot snap
        in _fireStore.collection(ARTICLES_COLLECTION).snapshots()) {
      List<Article> res = [];
      for (final doc in snap.docs) {
        final data = doc.data();
        final Article article = Article.fromDoc(doc.id, data);
        res.add(article);
      }
      yield res;
    }
  }

  Future<Article> addArticle(Article article) async {
    String id = article.id;
    if (article.id.isEmpty)
      id = (await _fireStore.collection(ARTICLES_COLLECTION).add(article.doc))
          .id;
    else
      await _fireStore
          .collection(ARTICLES_COLLECTION)
          .doc(article.id)
          .update(article.doc);
    return article.copyWithId(id);
  }
}
