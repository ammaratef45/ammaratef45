class MyInfo {
  final String name;
  final String subtitle;
  final String about;

  MyInfo({this.name, this.subtitle, this.about});

  MyInfo.fromDoc(Map<String, dynamic> doc)
      : name = doc['name'],
        subtitle = doc['subtitle'],
        about = doc['about'];
}
