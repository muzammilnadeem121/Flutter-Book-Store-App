import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return doc.data();
  }

  Future<void> changeProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      await FirebaseFirestore.instance.collection('user').doc(user!.uid).update(
        {'photoUrl': base64Image},
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> saveProfile(String name, String? photoUrl) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(user!.uid).update(
        {'name': name, 'photoUrl': photoUrl},
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getUserAvatar(String userId) async {
    try {
      final doc = await _firestore.collection('user').doc(userId).get();
      if (doc.exists) {
        return doc['photoUrl'] ?? '';
      }
    } catch (e) {
      print("Failed to fetch user avatar: $e");
    }
    return ''; // fallback if not found
  }

  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('user').doc(uid).get();
    return doc.data()?['role'] ?? 'user';
  }
}
