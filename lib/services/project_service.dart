import 'package:ammaratef45Flutter/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        final Project project = Project.fromDoc(doc.id, data);
        res.add(project);
      }
      yield res;
    }
  }

  Future<void> addProject(Project project) async {
    if (project.id.isEmpty)
      await _fireStore.collection(PROJECTS_COLLECTION).add(project.doc);
    else
      await _fireStore
          .collection(PROJECTS_COLLECTION)
          .doc(project.id)
          .update(project.doc);
  }
}
