// Widget 4: Password Input Field
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;

  const PasswordInputField({
    Key? key,
    required this.controller,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey[700]),
          errorText: errorText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
