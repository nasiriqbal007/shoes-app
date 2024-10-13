// ignore_for_file: empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/fav_model.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/services/user_db_service.dart';

class FavoriteController extends GetxController {
  RxList<FavoriteItem> favorites = <FavoriteItem>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFavoriteEmpty = true.obs;
  final AuthController authController = Get.find<AuthController>(tag: 'auth');
  final UserDatabaseService userDbService = UserDatabaseService();

  @override
  void onInit() {
    super.onInit();
    listenToFavorites();
  }

  Future<void> listenToFavorites() async {
    isLoading.value = true;
    User? user = authController.currentUser;
    if (user != null) {
      userDbService.getFavoriteItemsStream(user.uid).listen((favoriteItems) {
        favorites.assignAll(favoriteItems.toSet());
        isFavoriteEmpty.value = favorites.isEmpty;
      }, onError: (error) {
        isLoading.value = false;
      });
    } else {
      isLoading.value = false;
      isFavoriteEmpty.value = favorites.isEmpty;
    }
    isLoading.value = false;
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    User? user = authController.currentUser;
    try {
      if (favorites.contains(item)) {
        await userDbService.removeFromFavorite(user!.uid, item.shoeId);
      } else {
        await userDbService.addItemToFavorite(user!.uid, item);
      }
      update();
    } catch (e) {}
  }

  Future<void> removeFavorite(FavoriteItem item) async {
    isLoading.value = true;
    User? user = authController.currentUser;
    if (user != null) {
      await userDbService.removeFromFavorite(user.uid, item.shoeId);
      favorites.remove(item);
      isLoading.value = false;
      isFavoriteEmpty.value = favorites.isEmpty;
    }
    isLoading.value = false;
  }

  bool isFavorite(String shoeId) {
    return favorites.any((item) => item.shoeId == shoeId);
  }
}
