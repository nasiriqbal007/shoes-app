import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/cart_model.dart';
import 'package:nike_store/Model/fav_model.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/controllers/cart_controller.dart';
import 'package:nike_store/controllers/favorite_controller.dart';
import 'package:nike_store/pages/shoe_details.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteController favoriteController;
  final CartController cartController;
  final FavoriteItem item;

  const FavoriteCard({
    super.key,
    required this.favoriteController,
    required this.cartController,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final shoe = Shoe(
      id: item.shoeId,
      name: item.shoeName,
      price: item.shoePrice,
      imagePath: item.shoeImagePath,
      description: item.shoeDescription,
    );
    final cart = CartItem(
      userId: favoriteController.authController.currentUser!.uid,
      shoeId: item.shoeId,
      shoeName: item.shoeName,
      shoePrice: item.shoePrice,
      shoeImagePath: item.shoeImagePath,
      shoeDescription: item.shoeDescription,
      category: item.category,
    );
    return Dismissible(
      key: ValueKey(item.shoeId),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.shopping_cart, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await favoriteController.removeFavorite(item);

          Get.snackbar(
            "Removed",
            "${item.shoeName} removed from favorites.",
            duration: const Duration(milliseconds: 1500),
          );
        } else if (direction == DismissDirection.startToEnd) {
          favoriteController.isLoading.value = true;

          await cartController.addItemToCart(cart);

          await favoriteController.listenToFavorites();

          favoriteController.isLoading.value = false;

          Get.snackbar(
            "Added",
            "${item.shoeName} added to cart.",
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          Get.to(() => ShoeDetails(
                category: item.category,
                shoe: shoe,
              ));
        },
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Image.network(item.shoeImagePath, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.shoeName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        item.shoeDescription,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                      ),
                      Text(
                        "${item.shoePrice.toStringAsFixed(0)} \$",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                if (favoriteController.isLoading.value)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
