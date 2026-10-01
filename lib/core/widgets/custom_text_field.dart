import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: leadingIcon,
        suffixIcon: trailingIcon,
      ),
    );
  }
}