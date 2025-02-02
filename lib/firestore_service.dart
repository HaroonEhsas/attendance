import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> syncAttendanceToFirestore(Map<String, dynamic> attendance) async {
    await firestore.collection('attendance').add(attendance);
  }

  Stream<QuerySnapshot> getAttendanceStream() {
    return firestore.collection('attendance').snapshots();
  }
}