import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/pages/login_page.dart';
import 'package:nike_store/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const paddingFactor = 0.05;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * paddingFactor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Image.asset(
                  'assets/nike_bg.png',
                  height: screenSize.height * 0.3,
                ),
              ),
              Text(
                "Just Do It",
                style: TextStyle(
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Text(
                  "Welcome to Nike Store, your go-to sneaker destination. Find your perfect pair and step in style",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: screenSize.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: CustomButton(
                    text: "Shop Now",
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('seen_intro', true);
                      Get.offAll(
                        () => const LoginPage(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
