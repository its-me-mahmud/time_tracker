import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  const FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) {
      return snapshot.docs.map((snapshot) {
        return builder(snapshot.data()!, snapshot.id);
      }).toList();
    });
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }
}
