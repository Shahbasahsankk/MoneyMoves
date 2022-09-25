import 'package:flutter/material.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:provider/provider.dart';

class DeleteDailogue extends StatelessWidget {
  const DeleteDailogue({
    super.key,
    required this.keyy,
  });
  final String keyy;
  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<AddCategoryProvider>(context,listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      content: const Text('Delete Category?'),
      actions: [
        TextButton(
          onPressed: ()async => await provider.deleteCategory(context, keyy),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        )
      ],
    );
  }
}
