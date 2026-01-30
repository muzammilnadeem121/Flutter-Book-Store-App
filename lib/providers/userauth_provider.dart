import 'package:e_project/models/user_model.dart';
import 'package:e_project/providers/book_provider.dart';
import 'package:e_project/providers/cart_provider.dart';
import 'package:e_project/providers/ratings_provider.dart';
import 'package:e_project/providers/reviews_provider.dart';
import 'package:e_project/providers/user_provider.dart';
import 'package:e_project/providers/wishlist_provider.dart';
import 'package:e_project/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _isloading = false;
  String _error = "";
  final AuthService _authService = AuthService();

  bool get isloading => _isloading;
  String get error => _error;

  Future<void> registerUser(UserModel userData) async {
    try {
      _isloading = true;
      _error = "";
      notifyListeners();

      await _authService.register(userData);

      _isloading = false;
      _error = "";
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isloading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _isloading = true;
    _error = "";
    notifyListeners();

    try {
      await _authService.login(email: email, password: password);

      ProfileProvider().getUserData();
      WishlistProvider().loadWishlist();
      RatingsProvider().loadUserRatings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  Future<void> logout({required BuildContext context}) async {
    try {
      await _authService.logout();
      context.read<ProfileProvider>().clear();
      context.read<BookProvider>().clear();
      context.read<CartProvider>().clear();
      context.read<RatingsProvider>().clear();
      context.read<ReviewsProvider>().clear();
      context.read<WishlistProvider>().clear();
      clear();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isloading = true;
    _error = "";
    notifyListeners();

    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  void clear() {
    _isloading = false;
    _error = "";
    notifyListeners();
  }
}
