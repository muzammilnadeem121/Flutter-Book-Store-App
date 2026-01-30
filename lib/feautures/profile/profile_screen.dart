import 'dart:convert';

import 'package:e_project/providers/user_provider.dart';
import 'package:e_project/providers/userauth_provider.dart';
import 'package:e_project/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileProvider>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = context.read<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isloading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(child: Text(provider.error));
          }

          final userData = provider.userData;
          if (userData == null) {
            return const Center(child: Text("No user data"));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData['photoUrl'] != null
                          ? MemoryImage(base64Decode(userData['photoUrl']))
                          : null,
                      child: userData['photoUrl'] == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: profileProvider.changeProfilePicture,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  userData['name'] ?? "No Name",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Email
                Text(
                  userData["email"] ?? "No Email",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Profile Options
                _profileTile(
                  icon: Icons.edit,
                  title: "Edit Profile",
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(appRoutes.editProfile);
                  },
                ),
                _profileTile(
                  icon: Icons.lock,
                  title: "Change Password",
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(appRoutes.changePassword);
                  },
                ),
                _profileTile(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () async {
                    await context.read<UserAuthProvider>().logout(
                      context: context,
                    );
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushReplacementNamed(appRoutes.login);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
