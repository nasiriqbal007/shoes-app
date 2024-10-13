import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/shoe_controller.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final shoeController = Get.find<ShoeController>(tag: "shoe");

    return TabBar(
      tabs: shoeController.shoeCategorie.map((category) {
        return Tab(text: category.shoeCategories);
      }).toList(),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
      controller: tabController,
    );
  }
}
