import 'package:flutter/material.dart';

class TextsStyles extends StatelessWidget {
  const TextsStyles({
    Key? key,
    this.fontSize,
    this.color,
    this.fontWeight,
    required this.name,
    this.fontStyle,
    this.textAlign,
  }) : super(key: key);
  final String name;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
    );
  }
}
