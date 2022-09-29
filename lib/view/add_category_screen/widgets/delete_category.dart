import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:provider/provider.dart';

class BottomDeleteCategory extends StatelessWidget {
  const BottomDeleteCategory({super.key, required this.keyy});
  final String keyy;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddCategoryProvider>(context, listen: false);
    return SizedBox(
      height: 50.h,
      child: Center(
        child: TextButton(
          onPressed: () => provider.deleteDailogue(context, keyy),
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
