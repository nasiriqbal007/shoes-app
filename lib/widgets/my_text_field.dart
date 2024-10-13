import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  final TextInputType keyboardType;

  final String? Function(String?)? validator;
  final bool isShowPassword;
  final VoidCallback? onToggleVisibility;

  const MyTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.isShowPassword = false,
      this.onToggleVisibility});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isShowPassword,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          suffixIcon: onToggleVisibility != null
              ? GestureDetector(
                  onTap: onToggleVisibility,
                  child: Icon(
                    isShowPassword ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
