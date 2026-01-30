import 'package:e_project/core/theme/app_theme.dart';
import 'package:e_project/feautures/admin/analytics/provider/admin_analytics_provider.dart';
import 'package:e_project/feautures/admin/manageUsers/provider/admin_users_provider.dart';
import 'package:e_project/providers/book_provider.dart';
import 'package:e_project/providers/cart_provider.dart';
import 'package:e_project/providers/ratings_provider.dart';
import 'package:e_project/providers/reviews_provider.dart';
import 'package:e_project/providers/user_provider.dart';
import 'package:e_project/providers/userauth_provider.dart';
import 'package:e_project/providers/wishlist_provider.dart';
import 'package:e_project/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => UserAuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => RatingsProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProvider(create: (_) => AdminUsersProvider()),
        ChangeNotifierProvider(create: (_) => AdminAnalyticsProvider()),
      ],

      child: myApp(),
    ),
  );
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: appRoutes.splash,
      routes: appRoutes.routes,
      onGenerateRoute: appRoutes.generateRoute,
    );
  }
}
