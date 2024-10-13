import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/cart_model.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/controllers/cart_controller.dart';
import 'package:nike_store/pages/shoe_details.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>(tag: 'cart');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (cartController.isCartEmpty.value) {
          return _buildEmptyCartMessage();
        } else {
          return _buildCartItemsList(cartController, context);
        }
      }),
    );
  }

  Widget _buildEmptyCartMessage() {
    return const Center(
      child: Text(
        "No items in cart",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildCartItemsList(
      CartController cartController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cartController.cart.length,
        itemBuilder: (context, index) {
          final cartItem = cartController.cart[index];
          return _buildDismissibleCartItem(cartItem, cartController, context);
        },
      ),
    );
  }

  Dismissible _buildDismissibleCartItem(
      CartItem cartItem, CartController cartController, BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.shoeId),
      background: _buildDismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartController.removeFromCart(cartItem.shoeId);
        Get.snackbar(
          "Item Removed",
          "${cartItem.shoeName}: has been removed from your cart.",
          duration: const Duration(milliseconds: 1500),
        );
      },
      child: _buildCartItemCard(cartItem, cartController, context),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Card _buildCartItemCard(
      CartItem cartItem, CartController cartController, BuildContext context) {
    return Card(
      color: Get.theme.colorScheme.secondary,
      child: ListTile(
        onTap: () {
          final shoe = Shoe(
            id: cartItem.shoeId,
            name: cartItem.shoeName,
            price: cartItem.shoePrice,
            imagePath: cartItem.shoeImagePath,
            description: cartItem.shoeDescription,
          );
          Get.to(() => ShoeDetails(shoe: shoe, category: cartItem.category));
        },
        contentPadding: const EdgeInsets.all(4),
        leading: Image.network(
          cartItem.shoeImagePath,
          fit: BoxFit.cover,
        ),
        title: Text(
          cartItem.shoeName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        subtitle: Text("${cartItem.shoePrice.toStringAsFixed(0)}\$"),
        trailing: _buildQuantityControl(cartItem, cartController),
      ),
    );
  }

  Widget _buildQuantityControl(
      CartItem cartItem, CartController cartController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            cartController.decreaseItemQuantity(cartItem);
          },
        ),
        GetBuilder<CartController>(
          init: cartController,
          builder: (controller) {
            return Text("${cartItem.quantity}");
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            cartController.increaseItemQuantity(cartItem);
          },
        ),
      ],
    );
  }
}
