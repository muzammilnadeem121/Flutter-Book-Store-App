import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_project/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/reviews_service.dart';

class ReviewsProvider extends ChangeNotifier {
  final ReviewsService _reviewsService = ReviewsService();
  final ProfileService _userService = ProfileService();

  User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  String _error = '';
  List<ReviewModel> _reviews = [];
  Map<String, String> _userAvatars = {};

  bool get isLoading => _isLoading;
  String get error => _error;
  List<ReviewModel> get reviews => _reviews;
  Map<String, String> get userAvatars => _userAvatars;

  Future<void> loadReviews(String bookId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _reviews = await _reviewsService.getReviews(bookId);
      final userIds = _reviews.map((r) => r.userId).toSet().toList();
      for (var id in userIds) {
        _userAvatars[id] = await _userService.getUserAvatar(id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String bookId,
    required String comment,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(_user!.uid)
          .get();

      // Correctly get the data map
      final data = snapshot.data();
      if (data == null) throw Exception("User data not found");

      final review = ReviewModel(
        userId: _user!.uid,
        userName: data['name'] ?? 'Anonymous',
        comment: comment,
        createdAt: DateTime.now(),
        likedBy: [],
      );
      await _reviewsService.addReview(bookId: bookId, review: review);
      _reviews.insert(0, review); // instant UI update
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike({
    required String bookId,
    required ReviewModel review,
  }) async {
    final index = _reviews.indexOf(review);
    final String currentUserId = _user!.uid;
    if (index == -1) return;

    // optimistic UI update
    final likedBy = List<String>.from(review.likedBy);

    likedBy.contains(currentUserId)
        ? likedBy.remove(currentUserId)
        : likedBy.add(currentUserId);

    _reviews[index] = ReviewModel(
      userId: review.userId,
      userName: review.userName,
      comment: review.comment,
      createdAt: review.createdAt,
      likedBy: likedBy,
    );

    notifyListeners();

    await _reviewsService.toggleLike(bookId: bookId, review: review);
  }

  bool isLikedBy(ReviewModel review) {
    return review.isLikedBy(_user!.uid);
  }

  Future<void> deleteReview({
    required String bookId,
    required Map<String, dynamic> review,
  }) async {
    try {
      await _reviewsService.deleteReview(bookId: bookId, review: review);

      // remove locally using userId
      _reviews.removeWhere((r) => r.userId == review['userId']);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clear() {
    _isLoading = false;
    _error = "";
    _reviews = [];
    _userAvatars = {};
    _user = null;
    notifyListeners();
  }
}
