import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> totalUsers() async {
    final snap = await _firestore.collection('user').get();
    return snap.docs.length;
  }

  Future<int> blockedUsers() async {
    final snap = await _firestore
        .collection('user')
        .where('isBlocked', isEqualTo: true)
        .get();
    return snap.docs.length;
  }

  Future<int> totalBooks() async {
    final snap = await _firestore.collection('books').get();
    return snap.docs.length;
  }

  Future<int> bestsellerBooks() async {
    final snap = await _firestore
        .collection('books')
        .where('isBestseller', isEqualTo: true)
        .get();
    return snap.docs.length;
  }

  Future<int> totalReviews() async {
    final books = await _firestore.collection('books').get();

    int count = 0;
    for (var doc in books.docs) {
      final reviews = doc.data()['reviews'];
      if (reviews is List) {
        count += reviews.length;
      }
    }
    return count;
  }
}
