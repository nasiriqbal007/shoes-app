import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/cart_model.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/controllers/cart_controller.dart';
import 'package:nike_store/controllers/visibility_controller.dart';
import 'package:nike_store/widgets/custom_button.dart';

class ShoeDetails extends StatelessWidget {
  const ShoeDetails({super.key, required this.shoe, required this.category});

  final Shoe shoe;
  final String category;

  @override
  Widget build(BuildContext context) {
    VisibilityController visibilityController = Get.put(VisibilityController());
    final ScrollController scrollController = ScrollController();
    final CartController cartController = Get.find<CartController>(tag: 'cart');
    scrollController.addListener(() {
      visibilityController.setVisibility(
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward);
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildImageAndName(context)),
            SliverToBoxAdapter(child: _buildDivider(context)),
            SliverToBoxAdapter(child: _buildSizeSelection(context)),
            SliverToBoxAdapter(child: _buildDivider(context)),
            SliverToBoxAdapter(child: _buildDescriptionTitle(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildDescription(context)),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => Visibility(
            visible: visibilityController.isVisible.value,
            child: _buildFabButton(cartController, shoe, context, category)),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        category,
        style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  Widget _buildImageAndName(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.network(
            shoe.imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Text(
            shoe.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(color: Theme.of(context).colorScheme.primary);
  }

  Widget _buildSizeSelection(BuildContext context) {
    final List<int> shoeSizes = [38, 39, 40, 41, 42, 43, 44, 45, 46, 47];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "${shoe.price.toStringAsFixed(0)}\$",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: shoeSizes.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _buildSizeCard(context, shoeSizes[index]);
            },
          ),
        ),
      ],
    );
  }

  Padding _buildSizeCard(BuildContext context, int size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          children: [
            Image.network(shoe.imagePath),
            Positioned(
              top: 5,
              left: 32,
              child: Center(
                child: Text(
                  size.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTitle(BuildContext context) {
    return Text(
      "Description",
      style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      shoe.description,
      style: TextStyle(
          fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary),
    );
  }
}

Widget _buildFabButton(CartController cartController, Shoe shoe,
    BuildContext context, String category) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.06,
    width: MediaQuery.of(context).size.width * 0.8,
    child: CustomButton(
      onPressed: () {
        cartController.addItemToCart(CartItem(
            userId: cartController.authController.currentUser!.uid,
            shoeId: shoe.id,
            shoeName: shoe.name,
            shoePrice: shoe.price,
            shoeImagePath: shoe.imagePath,
            shoeDescription: shoe.description,
            category: category));
        Get.snackbar(
          "Item Added",
          "The item has been successfully added to your cart.",
          duration: const Duration(milliseconds: 1500),
        );
      },
      text: 'Add to cart',
    ),
  );
}
