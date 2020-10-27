class Article {
  static const String NAME_KEY = 'name';
  static const String CONTENT_KEY = 'description';
  static const String IMAGE_KEY = 'image';
  final String name;
  final String content;
  final String image;
  final String id;

  Article.fromDoc(String id, Map<String, dynamic> doc)
      : this._(id, doc[NAME_KEY], doc[CONTENT_KEY], doc[IMAGE_KEY]);

  Article._(this.id, this.name, this.content, this.image);

  Map<String, dynamic> get doc =>
      {NAME_KEY: name, CONTENT_KEY: content, IMAGE_KEY: image};

  Article copyWithImage(String newImage) {
    return Article._(id, name, content, newImage);
  }

  Article copyWithId(String newId) {
    return Article._(newId, name, content, image);
  }
}
