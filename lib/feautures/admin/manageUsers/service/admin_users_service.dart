import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_project/models/user_model.dart';

class AdminUsersService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await _firestore.collection('user').get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  Future<void> toggleBlockUser(String? uid, bool block) async {
    if (uid == null) return;
    await _firestore.collection('user').doc(uid).update({'isBlocked': block});
  }

  Future<void> changeRole(String? uid, String role) async {
    if (uid == null) return;
    await _firestore.collection('user').doc(uid).update({'role': role});
  }
}
