class Project {
  static const String NAME_KEY = 'name';
  static const String DESC_KEY = 'description';
  static const String IMAGE_KEY = 'image';
  final String name;
  final String description;
  final String image;
  final String id;

  Project.fromDoc(String id, Map<String, dynamic> doc)
      : this._(id, doc[NAME_KEY], doc[DESC_KEY], doc[IMAGE_KEY]);

  Project._(this.id, this.name, this.description, this.image);

  Map<String, dynamic> get doc =>
      {NAME_KEY: name, DESC_KEY: description, IMAGE_KEY: image};
}
