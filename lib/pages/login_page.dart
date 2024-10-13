import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/pages/register_page.dart';
import 'package:nike_store/widgets/custom_button.dart';
import 'package:nike_store/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>(tag: 'auth');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Welcome Back",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 25)),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: 'Email',
                  controller: authController.emailControllerLogin,
                  keyboardType: TextInputType.emailAddress,
                  validator: authController.validateEmail,
                ),
                Obx(() {
                  return MyTextField(
                    hintText: 'Password',
                    controller: authController.passwordControllerLogin,
                    validator: authController.validatePassword,
                    isShowPassword: !authController.isShowPasswordLogin.value,
                    onToggleVisibility: () =>
                        authController.toggleLoginPasswordVisibility(),
                  );
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Obx(() {
                    return CustomButton(
                        text: authController.isLoading.value
                            ? "Logging in..."
                            : "Login",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login();
                          }
                        });
                  }),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const RegisterPage());
                    authController.clearControllers();
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
