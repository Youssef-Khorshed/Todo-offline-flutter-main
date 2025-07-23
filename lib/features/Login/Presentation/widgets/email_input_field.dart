// Widget 3: Email Input Field
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;

  const EmailInputField({
    Key? key,
    required this.controller,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff254DDE),
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.grey[700]),
          errorText: errorText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
