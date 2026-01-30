import 'package:e_project/feautures/Auth/login_screen.dart';
import 'package:e_project/feautures/Auth/register_screen.dart';
import 'package:e_project/feautures/admin/adminPanel_screen.dart';
import 'package:e_project/feautures/admin/analytics/admin_analytics_screen.dart';
import 'package:e_project/feautures/admin/manageReviews/reviews_screen.dart';
import 'package:e_project/feautures/admin/manageReviews/reviewsbooks_screen.dart';
import 'package:e_project/feautures/admin/manageUsers/manage_users_screen.dart';
import 'package:e_project/feautures/bookDetails/bookDetails_screen.dart';
import 'package:e_project/feautures/changePassword/changePassword_screen.dart';
import 'package:e_project/feautures/editProfile/editProfile_screen.dart';
import 'package:e_project/feautures/layout/layout.dart';
import 'package:e_project/feautures/splash/splash_screen.dart';
import 'package:e_project/feautures/wishlist/wishlist_screen.dart';
import 'package:e_project/feautures/admin/manageBooks/manageBooks_scree.dart';
import 'package:e_project/models/book_model.dart';
import 'package:flutter/material.dart';

class appRoutes {
  static const splash = '/';
  static const main = '/main';
  static const bookDetails = '/book/book-details';
  static const register = '/register';
  static const login = '/login';
  static const editProfile = '/profile/edit-profile';
  static const changePassword = '/profile/change-password';
  static const wishlist = '/wishlist';
  static const adminPanel = '/admin-panel';
  static const manageBooks = '/admin-panel/manage-books';
  static const manageReviewsBooks = "/admin-panel/manage-reviews-books";
  static const manageReviews =
      '/admin-panel/manage-reviews-books/manage-reviews';
  static const manageUsers = "/admin-panel/manage-users";
  static const analytics = "/admin-panel/analytics";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    main: (context) => const MainLayout(),
    register: (context) => const RegisterScreen(),
    login: (context) => const LoginScreen(),
    adminPanel: (context) => const AdminPanelScreen(),
    manageBooks: (context) => const ManageBooksScreen(),
    manageReviewsBooks: (context) => const ReviewsbooksScreen(),
    manageUsers: (context) => const AdminUsersScreen(),
    analytics: (context) => const AdminAnalyticsScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case bookDetails:
        final book = settings.arguments as Book;
        return MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book));

      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case changePassword:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      case wishlist:
        return MaterialPageRoute(builder: (_) => WishlistScreen());

      case adminPanel:
        return MaterialPageRoute(builder: (_) => AdminPanelScreen());

      case manageBooks:
        return MaterialPageRoute(builder: (_) => ManageBooksScreen());

      case manageReviewsBooks:
        return MaterialPageRoute(builder: (_) => ReviewsbooksScreen());

      case manageReviews:
        final bookId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ReviewsAdminScreen(bookId: bookId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
