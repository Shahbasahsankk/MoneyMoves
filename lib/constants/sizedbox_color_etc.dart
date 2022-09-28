import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var sizedboxW20 = SizedBox(width: 20.w);
var sizedboxW30 = SizedBox(width: 30.w);
var sizedboxW15 = SizedBox(width: 15.w);
var sizedboxW80 = SizedBox(width: 80.w);
var sizedboxH20 = SizedBox(height: 20.h);
var sizedboxH30 = SizedBox(height: 30.h);
var sizedboxH90 = SizedBox(height: 90.h);
var sizedboxH100 = SizedBox(height: 100.h);

final contentPadding =
    EdgeInsets.only(top: 18.h, left: 14.w, bottom: 18.h, right: 12.w);
final padding = EdgeInsets.only(left: 20.w, right: 20.w, top: 9.h, bottom: 9.h);

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

SnackBar customSnackBar(text) => SnackBar(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
