import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/widgets/my_drawer.dart';
import 'package:nike_store/widgets/my_sliver_appbar.dart';
import 'package:nike_store/widgets/my_tab_bar.dart';
import 'package:nike_store/widgets/shoe_card.dart';
import 'package:nike_store/controllers/shoe_controller.dart';
import 'package:nike_store/pages/shoe_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShoeController shoeController = Get.find<ShoeController>(tag: "shoe");

    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        if (shoeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (shoeController.errorMessage.value.isNotEmpty) {
          return Center(child: Text(shoeController.errorMessage.value));
        }

        if (shoeController.shoeCategorie.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        return NestedScrollView(
          headerSliverBuilder: (context, innerScroll) => [
            MySliverAppbar(
              title: MyTabBar(tabController: shoeController.tabController),
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                child: Center(
                  child: Text(
                    'Step up your style & performance with our diverse shoe collection',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
          body: _buildTabBarView(shoeController),
        );
      }),
    );
  }

  Widget _buildTabBarView(ShoeController shoeController) {
    return TabBarView(
      controller: shoeController.tabController,
      children: shoeController.shoeCategorie.map((category) {
        return _buildShoeList(category);
      }).toList(),
    );
  }

  Widget _buildShoeList(ShoeCategory category) {
    return ListView.builder(
      itemCount: category.shoes.length,
      itemBuilder: (context, index) {
        final shoe = category.shoes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: ShoeCard(
            shoe: shoe,
            category: category.shoeCategories,
            onTap: () {
              Get.to(
                () => ShoeDetails(
                  shoe: shoe,
                  category: category.shoeCategories,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
