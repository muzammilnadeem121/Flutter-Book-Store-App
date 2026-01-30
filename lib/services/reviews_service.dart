import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';

class ReviewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> addReview({
    required String bookId,
    required ReviewModel review,
  }) async {
    final bookRef = _firestore.collection('books').doc(bookId);
    try {
      await bookRef.update({
        'reviews': FieldValue.arrayUnion([review.toMap()]),
      });
    } catch (e) {
      throw "Failed to add review: $e";
    }
  }

  Future<List<ReviewModel>> getReviews(String bookId) async {
    final doc = await _firestore.collection('books').doc(bookId).get();

    final data = doc.data();
    if (data == null || data['reviews'] == null) return [];

    return (data['reviews'] as List)
        .map((e) => ReviewModel.fromMap(e))
        .toList();
  }

  Future<void> toggleLike({
    required String bookId,
    required ReviewModel review,
  }) async {
    final bookRef = _firestore.collection('books').doc(bookId);
    final String currentUserId = _user!.uid;

    final snapshot = await bookRef.get();
    final reviews = List<Map<String, dynamic>>.from(snapshot['reviews']);

    final index = reviews.indexWhere(
      (r) =>
          r['userId'] == currentUserId &&
          r['createdAt'] == review.createdAt.toIso8601String(),
    );

    if (index == -1) return;

    final likedBy = List<String>.from(reviews[index]['likedBy'] ?? []);

    likedBy.contains(currentUserId)
        ? likedBy.remove(currentUserId)
        : likedBy.add(currentUserId);

    reviews[index]['likedBy'] = likedBy;

    await bookRef.update({'reviews': reviews});
  }

  Future<void> deleteReview({
    required String bookId,
    required Map<String, dynamic> review,
  }) async {
    await _firestore.collection('books').doc(bookId).update({
      'reviews': FieldValue.arrayRemove([review]),
    });
  }
}
