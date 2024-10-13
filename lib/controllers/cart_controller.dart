import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/cart_model.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/services/user_db_service.dart';

class CartController extends GetxController {
  final cart = <CartItem>[].obs;
  RxBool isLoading = false.obs;

  final UserDatabaseService userDbService = UserDatabaseService();
  final AuthController authController = Get.find<AuthController>(tag: 'auth');
  RxBool isCartEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    isLoading.value = true;
    try {
      User? user = authController.currentUser;
      cart.clear();
      if (user != null) {
        final items = await userDbService.getCartItems(user.uid);
        cart.value = items;
      }
    } catch (e) {
      cart.value = [];
    } finally {
      isLoading.value = false;
      isCartEmpty.value = cart.isEmpty;
    }
  }

  Future<void> addItemToCart(CartItem cartItem) async {
    isLoading.value = true;

    User? user = authController.currentUser;

    if (user != null) {
      await userDbService.addItemToCart(user.uid, cartItem);
      await loadCartItems();
    }
    isLoading.value = false;
    isCartEmpty.value = cart.isEmpty;
  }

  Future<void> removeFromCart(String cartItemId) async {
    isLoading.value = true;

    User? user = authController.currentUser;
    if (user != null) {
      await userDbService.removeFromCart(user.uid, cartItemId);
      await loadCartItems();
    }

    isLoading.value = false;
    isCartEmpty.value = cart.isEmpty;
  }

  Future<void> increaseItemQuantity(CartItem cartItem) async {
    cartItem.increaseQuantity();
    update();

    User? user = authController.currentUser;
    if (user != null) {
      await userDbService.updateCartItemQuantity(user.uid, cartItem);
    }
  }

  Future<void> decreaseItemQuantity(CartItem cartItem) async {
    if (cartItem.quantity > 1) {
      cartItem.decreaseQuantity();
      update();

      User? user = authController.currentUser;
      if (user != null) {
        await userDbService.updateCartItemQuantity(user.uid, cartItem);
      }
    } else {
      await removeFromCart(cartItem.shoeId);
    }
  }
}
