import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/add_transaction/add_transaction_controller.dart';
import 'package:provider/provider.dart';

class CategoryAdd extends StatelessWidget {
  const CategoryAdd({super.key, required this.formkey2});
  final dynamic formkey2;
  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<AddCategoryProvider>(context, listen: false);
    final transactionProvider =
        Provider.of<AddTransactionProvider>(context, listen: false);

    return SimpleDialog(
      title: const Text('New Category'),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 23.w, right: 23.w),
          child: Form(
            key: formkey2,
            child: Consumer<AddTransactionProvider>(
              builder: (context,values,_) {
                return TextFormField(
                  textCapitalization: TextCapitalization.words,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => transactionProvider.newCategoryValidation(
                    value,
                    categoryProvider.incomeModelList,
                    categoryProvider.expenseModelList,
                    values.categoryController.text,
                  ),
                  maxLength: 10,
                  controller: categoryProvider.categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Enter new Category',
                  ),
                );
              }
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                categoryProvider.categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => transactionProvider.newCategoryAdding(
                formkey2.currentState!,
                categoryProvider.categoryController.text,
                context,
              ),
              child: const Text('Add'),
            )
          ],
        ),
      ],
    );
  }
}
