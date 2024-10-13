import 'package:get/get.dart';

class VisibilityController extends GetxController {
  var currentIndex = 0.obs;
  RxBool isVisible = true.obs;

  void setVisibility(bool visible) {
    isVisible.value = visible;
  }
}
