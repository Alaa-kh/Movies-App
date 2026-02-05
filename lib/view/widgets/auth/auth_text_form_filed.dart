import 'package:flutter/material.dart';
import '../../../utils/theme.dart';

class AuthTextFormField extends StatefulWidget {
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
    this.onSubmitted,
  });

  final String hintText;
  final bool obscureText;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late final FocusNode _focusNode;
  TextDirection? _textDirection;
  TextDirection? _fallbackDirection;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fallbackDirection ??= Directionality.of(context);
    _textDirection ??=
        _detectDirection(widget.controller.text, fallback: _fallbackDirection!);
  }

  void _onTextChanged() {
    final fallback = _fallbackDirection;
    if (fallback == null) return;

    final next = _detectDirection(widget.controller.text, fallback: fallback);
    if (next != _textDirection) {
      setState(() => _textDirection = next);
    }
  }

  TextDirection _detectDirection(String text,
      {required TextDirection fallback}) {
    final t = text.trimLeft();
    if (t.isEmpty) return fallback;

    final first = t.runes.first;
    return _isArabicRune(first) ? TextDirection.rtl : TextDirection.ltr;
  }

  bool _isArabicRune(int rune) {
    return (rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0x08A0 && rune <= 0x08FF) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fillColor = Color(0xFFF6F7FB);
    const textColor = Color(0xFF111827);
    const hintColor = Color(0xFF9CA3AF);

    final borderRadius = BorderRadius.circular(16);

    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: const BorderSide(
        color: Color(0xFFE5E7EB),
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: mainClr.withOpacity(.95),
        width: 1.4,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: Colors.red.shade400,
        width: 1.2,
      ),
    );
const errorColor = Colors.red;

    final direction = _textDirection ?? Directionality.of(context);

    return Directionality(
      textDirection: direction,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: gryClr.withOpacity(.12),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(
            color: textColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            errorStyle: const TextStyle(
              color: errorColor,
              height: 1.2,
            ),
            filled: true,
            fillColor: fillColor,
            prefixIcon: IconTheme(
              data: const IconThemeData(color: gryClr),
              child: widget.prefixIcon,
            ),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: hintColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: enabledBorder,
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
        ),
      ),
    );
  }
}
