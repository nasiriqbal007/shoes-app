import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/Model/user_model.dart';
import 'package:nike_store/pages/home_page.dart';
import 'package:nike_store/pages/login_page.dart';
import 'package:nike_store/services/authservice.dart';
import 'package:nike_store/services/user_db_service.dart';

class AuthController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailControllerLogin = TextEditingController();
  final TextEditingController passwordControllerLogin = TextEditingController();

  Rxn<UserModel?> userModel = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  final Authservice authservice = Authservice();
  final UserDatabaseService userDbService = UserDatabaseService();

  User? get currentUser => FirebaseAuth.instance.currentUser;
  RxBool isShowPasswordLogin = false.obs;
  RxBool isShowPasswordRegister = false.obs;

  void toggleLoginPasswordVisibility() {
    isShowPasswordLogin.value = !isShowPasswordLogin.value;
  }

  void toggleRegisterPasswordVisibility() {
    isShowPasswordRegister.value = !isShowPasswordRegister.value;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    clearControllers();
    listenToAuthChanges();
  }

  @override
  void onClose() {
    clearControllers();
    super.onClose();
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    emailControllerLogin.clear();
    passwordControllerLogin.clear();
  }

  Future<void> login() async {
    isLoading.value = true;
    String email = emailControllerLogin.text;
    String password = passwordControllerLogin.text;
    try {
      User? user =
          await authservice.signInWithEmailAndPassword(email, password);
      if (user != null) {
        userModel.value = await userDbService.getUser(user.uid);

        Get.offAll(() => const HomePage());
        emailControllerLogin.clear();
        passwordControllerLogin.clear();
      }
    } catch (error) {
      Get.snackbar("Login Failed", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
    isLoading.value = false;
  }

  Future<void> register() async {
    isLoading.value = true;
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await authservice.registerUserWithEmailAndPassword(
          name, email, password);

      if (user != null) {
        userModel.value = await userDbService.getUser(user.uid);

        Get.offAll(() => const HomePage());

        await Future.delayed(const Duration(milliseconds: 500));

        nameController.clear();
        emailController.clear();
        passwordController.clear();
      }
    } catch (error) {
      Get.snackbar("Registration Failed", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        isLoading(true);
        UserModel? fetchedUser = await userDbService.getUser(user.uid);
        userModel.value = fetchedUser;
        isLoading(false);
      } else {
        userModel.value = null;
      }
    });
  }

  Future<void> signOut() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    await authservice.signOut();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAll(() => const LoginPage());
      userModel.value = null;
      isLoading.value = false;
    });
  }
}
