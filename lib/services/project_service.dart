import 'package:ammaratef45Flutter/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO complete implementation for adding projects (admin usage)
class ProjectsService {
  static const String PROJECTS_COLLECTION = 'projects';
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ProjectsService._();
  static ProjectsService _instance;

  static ProjectsService get instance {
    if (_instance == null) {
      _instance = ProjectsService._();
    }
    return _instance;
  }

  Stream<List<Project>> getProjectsStream() async* {
    await for (final QuerySnapshot snap
        in _fireStore.collection(PROJECTS_COLLECTION).snapshots()) {
      List<Project> res = [];
      for (final doc in snap.docs) {
        final data = doc.data();
        final Project project =
            Project(data['name'], data['description'], data['image']);
        res.add(project);
      }
      yield res;
    }
  }
}
