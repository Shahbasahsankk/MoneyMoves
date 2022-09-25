import 'package:flutter/material.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({
    super.key,
    required this.formkey,
    required this.tabController,
  });
  final dynamic formkey;
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddCategoryProvider>(context, listen: false);
    return AlertDialog(
      title: const Text('New Category'),
      content: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formkey,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              provider.addCategoryValidation(tabController, value),
          controller: provider.categoryController,
          decoration: const InputDecoration(hintText: 'Enter new Category'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            provider.categoryController.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: ()async => await provider.categoryAdded(
              formkey.currentState!, tabController, context),
          child: const Text('Add'),
        )
      ],
    );
  }
}
