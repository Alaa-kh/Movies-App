import 'package:flutter/material.dart';

import '../../../utils/theme.dart';

class AuthTextFormField extends StatelessWidget {
  AuthTextFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);
  final String hintText;
  bool obscureText;
  final Function validator;
  final TextEditingController controller;
  final Widget prefixIcon;
  Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gryClr.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade400,
          )),
      child: TextFormField(
        validator: (value) => validator(value),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: const TextStyle(color: gryClr, fontSize: 13)),
      ),
    );
  }
}
