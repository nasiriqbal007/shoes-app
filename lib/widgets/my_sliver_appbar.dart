import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/pages/cart_page.dart';
import 'package:nike_store/pages/favorite_page.dart';

class MySliverAppbar extends StatelessWidget {
  const MySliverAppbar({super.key, required this.title, required this.child});
  final Widget title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      collapsedHeight: MediaQuery.of(context).size.height * 0.15,
      expandedHeight: MediaQuery.of(context).size.height * 0.25,
      title: Text("Nike Store",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom * 0.5,
          ),
          child: child,
        ),
        titlePadding: const EdgeInsets.only(
          right: 0,
          left: 0,
          top: 0,
        ),
        expandedTitleScale: 1,
        title: title,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const CartPage());
          },
          icon: const Icon(
            Icons.shopping_cart,
            size: 28,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: IconButton(
            onPressed: () {
              Get.to(() => const FavoritePage());
            },
            icon: const Icon(
              Icons.favorite,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
