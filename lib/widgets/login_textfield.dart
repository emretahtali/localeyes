import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String title;
  final bool obscure;
  final Icon? icon;
  final TextEditingController controller = TextEditingController();
  AuthTextField(
      {super.key, required this.title, required this.obscure, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: icon,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
    );
  }

  String get text => controller.text.trim();
  TextEditingController get textController => controller;
}
