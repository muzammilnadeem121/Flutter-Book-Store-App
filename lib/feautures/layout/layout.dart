import 'package:e_project/feautures/cart/cart_screen.dart';
import 'package:e_project/feautures/home/home_screen.dart';
import 'package:e_project/feautures/profile/profile_screen.dart';
import 'package:e_project/feautures/search/search_screen.dart';
import 'package:e_project/providers/user_provider.dart';
import 'package:e_project/routes/app_routes.dart';
import 'package:e_project/widgets/brand.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller = PersistentTabController(
      initialIndex: 0,
    );

    List<Widget> screens() => [
      const HomeScreen(),
      const SearchScreen(),
      const CartScreen(),
      ProfileScreen(),
    ];

    List<PersistentBottomNavBarItem> navItems() => [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: "Search",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart),
        title: "Cart",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("/images/logo.png"),
        title: const Brand(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(appRoutes.wishlist);
            },
            icon: Icon(Icons.favorite_border),
          ),
          Consumer<ProfileProvider>(
            builder: (context, provider, _) {
              provider.loadRole(FirebaseAuth.instance.currentUser!.uid);
              if (provider.isAdmin) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(appRoutes.adminPanel);
                  },
                  icon: Icon(Icons.dashboard),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
      body: PersistentTabView(
        context,
        controller: controller,
        screens: screens(),
        items: navItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        navBarHeight: kBottomNavigationBarHeight,
        animationSettings: const NavBarAnimationSettings(
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            animateTabTransition: true,
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
        navBarStyle: NavBarStyle.neumorphic,
      ),
    );
  }
}
