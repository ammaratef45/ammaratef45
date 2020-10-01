import 'package:ammaratef45Flutter/models/myinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoService {
  static const String MY_INFO_COLLECTION = 'myInfo';
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  InfoService._();
  static InfoService _instance;

  static InfoService get instance {
    if (_instance == null) {
      _instance = InfoService._();
    }
    return _instance;
  }

  Future<MyInfo> getMyInfo() async {
    DocumentSnapshot snap = await _fireStore
        .collection(MY_INFO_COLLECTION)
        .doc(MY_INFO_COLLECTION)
        .get();
    return MyInfo.fromDoc(snap.data());
  }
}
