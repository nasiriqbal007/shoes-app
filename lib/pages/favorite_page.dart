import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/cart_controller.dart';
import 'package:nike_store/controllers/favorite_controller.dart';
import 'package:nike_store/widgets/fav_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController =
        Get.find<FavoriteController>(tag: 'fav');
    final CartController cartController = Get.find<CartController>(tag: 'cart');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Obx(() {
          if (favoriteController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoriteController.favorites.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteController.favorites.length,
            itemBuilder: (context, index) {
              final item = favoriteController.favorites[index];
              return FavoriteCard(
                favoriteController: favoriteController,
                cartController: cartController,
                item: item,
              );
            },
          );
        }),
      ),
    );
  }
}
