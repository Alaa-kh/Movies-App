import 'package:flutter/material.dart';
import '../../../utils/theme.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
  });

  final String hintText;
  final bool obscureText;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return FormField<String>(
      validator: validator,
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  color: state.hasError ? errorColor : Colors.grey.shade400,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                onChanged: (v) {
                  state.didChange(v);
                  if (state.hasError) state.validate();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: gryClr, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
