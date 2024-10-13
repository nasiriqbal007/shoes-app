import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/controllers/cart_controller.dart';
import 'package:nike_store/controllers/favorite_controller.dart';
import 'package:nike_store/controllers/shoe_controller.dart';
import 'package:nike_store/controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nike_store/pages/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.lazyPut(() => AuthController(), tag: "auth", fenix: true);
  Get.lazyPut(() => FavoriteController(), tag: "fav", fenix: true);
  Get.lazyPut(() => ShoeController(), tag: "shoe", fenix: true);
  Get.lazyPut(() => CartController(), tag: "cart", fenix: true);
  Get.lazyPut(() => ThemeController(), tag: "theme", fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      tag: 'theme',
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nike Store',
          theme: Get.find<ThemeController>(tag: "theme").themeData,
          home: AuthGate(),
        );
      },
    );
  }
}
