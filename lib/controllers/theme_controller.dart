import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/theme/dark_theme.dart';
import 'package:nike_store/theme/light_theme.dart';

class ThemeController extends GetxController {
  bool isDarktheme = false;
  ThemeData get themeData => isDarktheme ? darkTheme : lightTheme;

  void toggleTheme() {
    isDarktheme = !isDarktheme;
    update();
  }
}
