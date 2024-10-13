import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nike_store/controllers/auth_controller.dart';
import 'package:nike_store/widgets/custom_button.dart';
import 'package:nike_store/widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => LoginPageState();
}

class LoginPageState extends State<RegisterPage> {
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
                    child: Text("Register",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 25))),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: 'name',
                  controller: authController.nameController,
                  keyboardType: TextInputType.text,
                  validator: authController.validateName,
                ),
                MyTextField(
                  hintText: 'Email',
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: authController.validateEmail,
                ),
                Obx(() {
                  return MyTextField(
                    hintText: 'Password',
                    controller: authController.passwordController,
                    validator: authController.validatePassword,
                    isShowPassword:
                        !authController.isShowPasswordRegister.value,
                    onToggleVisibility: () =>
                        authController.toggleRegisterPasswordVisibility(),
                  );
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Obx(() {
                    return CustomButton(
                        text: authController.isLoading.value
                            ? "Registering..."
                            : "Register",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.register();
                          }
                        });
                  }),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    authController.clearControllers();
                  },
                  child: Text(
                    "Already have an account? Login",
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
