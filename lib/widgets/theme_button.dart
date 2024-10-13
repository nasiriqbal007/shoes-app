import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/theme_controller.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ThemeController>(tag: "theme");

    return GetBuilder<ThemeController>(
        tag: 'theme',
        builder: (controller) {
          return AnimatedToggleSwitch<bool>.dual(
            current: controller.isDarktheme,
            first: false,
            second: true,
            indicatorSize: const Size(25.0, 25.0),
            height: 30.0,
            spacing: -10,
            style: ToggleStyle(
              borderColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            inactiveOpacityCurve: Curves.easeOutQuart,
            styleAnimationType: AnimationType.onSelected,
            fittingMode: FittingMode.none,
            onChanged: (value) {
              controller.toggleTheme();
            },
            iconBuilder: (value) {
              return value
                  ? Icon(
                      Icons.nightlight_round,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Icon(Icons.wb_sunny,
                      color: Theme.of(context).colorScheme.inversePrimary);
            },
          );
        });
  }
}
