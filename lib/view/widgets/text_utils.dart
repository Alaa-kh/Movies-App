import 'package:flutter/material.dart';

class TextUtils extends StatelessWidget {
  const TextUtils({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.overflow,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: TextStyle(
          overflow: overflow,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: TextDecoration.none),
    );
  }
}
