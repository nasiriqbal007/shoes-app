import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/pages/home_page.dart';
import 'package:nike_store/pages/login_page.dart';
import 'package:nike_store/pages/intro_page.dart'; // Import the IntroPage
import 'package:nike_store/services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatelessWidget {
  final Authservice authservice = Authservice();

  AuthGate({super.key});

  Future<bool> _checkIfSeenIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_intro') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: FutureBuilder<bool>(
          future: _checkIfSeenIntro(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (!snapshot.data!) {
                return const IntroPage();
              }

              return FutureBuilder<User?>(
                future: Future.delayed(
                    Duration.zero, () => authservice.getCurrentUser()),
                builder: (context, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (authSnapshot.hasError) {
                    return Center(child: Text('Error: ${authSnapshot.error}'));
                  } else {
                    final user = authSnapshot.data;
                    return user != null ? const HomePage() : const LoginPage();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
