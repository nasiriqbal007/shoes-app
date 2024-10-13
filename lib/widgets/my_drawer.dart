import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/widgets/theme_button.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>(tag: 'auth');
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    "assets/nike_bg.png",
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authController.userModel.value?.name ?? 'Guest',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      authController.userModel.value?.email ?? 'No email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Theme Toggle Section
            ListTile(
              title: Text(
                'Theme',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              trailing: const ThemeButton(),
            ),
            const SizedBox(height: 20),

            // Logout Section
            Obx(() {
              return ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                trailing: authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : IconButton(
                        onPressed: () async {
                          authController.signOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 28,
                        ),
                      ),
              );
            })
          ],
        ),
      ),
    );
  }
}
