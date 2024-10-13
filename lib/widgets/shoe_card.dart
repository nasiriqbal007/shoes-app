import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/fav_model.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/controllers/favorite_controller.dart';

class ShoeCard extends StatelessWidget {
  final Shoe shoe;
  final String category;
  final void Function()? onTap;
  const ShoeCard({
    super.key,
    required this.shoe,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController =
        Get.find<FavoriteController>(tag: 'fav');
    final favoriteItem = FavoriteItem(
      userId: favoriteController.authController.currentUser!.uid,
      shoeId: shoe.id,
      shoeName: shoe.name,
      shoePrice: shoe.price,
      shoeImagePath: shoe.imagePath,
      shoeDescription: shoe.description,
      category: category,
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  child: Image.network(
                    shoe.imagePath,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 10,
                  child: Obx(() {
                    bool isFav =
                        favoriteController.isFavorite(favoriteItem.shoeId);
                    return IconButton(
                      onPressed: () {
                        favoriteController.toggleFavorite(favoriteItem);
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_outline,
                        color: isFav
                            ? Colors.red
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                    );
                  }),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: Text(
                    shoe.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: Text(
                    "Price: ${shoe.price.toStringAsFixed(0)}\$",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
