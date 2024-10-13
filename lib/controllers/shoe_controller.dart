import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/shoes_model.dart';
import 'package:nike_store/services/shoe_database.dart';

class ShoeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<ShoeCategory> shoeCategorie = <ShoeCategory>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  late TabController tabController;

  final ShoeDatabaseService shoeDatabaseService = ShoeDatabaseService();

  @override
  void onInit() {
    super.onInit();
    fetchShoeCategories();
  }

  Future<void> fetchShoeCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final categories =
          await shoeDatabaseService.fetchAllCategoriesWithShoes();
      if (categories.isEmpty) {
        errorMessage.value = 'No categories found.';
      } else {
        shoeCategorie.assignAll(categories);
        tabController = TabController(
            length: shoeCategorie.length, vsync: this); // Initialize here
      }
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tabController.dispose(); // Dispose the tab controller
    super.onClose();
  }
}
