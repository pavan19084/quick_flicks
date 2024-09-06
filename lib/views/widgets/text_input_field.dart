import 'package:flutter/material.dart';
import 'package:quick_flicks/constans.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labeltext;
  final bool isObsure;
  final IconData icon;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labeltext,
    this.isObsure = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labeltext,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
      ),
      obscureText: isObsure,
    );
  }
}
