import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Screens/add_screen.dart';

// ignore: must_be_immutable
class AddDetails extends StatelessWidget {
  AddDetails({
    Key? key,
    required this.hintText,
    this.color,
    this.iconData,
    this.ontap,
    this.controller,
    this.readonly = false,
    this.keyboardType,
    required this.validator,
    this.maxLength,
  }) : super(key: key);

  final String hintText;
  final Color? color;
  final IconData? iconData;
  void Function()? ontap;
  final bool? readonly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: ontap,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readonly!,
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          suffixIcon: Icon(
            iconData,
            color: color,
            size: 25.sp,
          ),
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
