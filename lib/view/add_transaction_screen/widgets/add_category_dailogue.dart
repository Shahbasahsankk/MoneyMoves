import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/add_transaction/add_transaction_controller.dart';
import 'package:provider/provider.dart';

class CategoryAdd extends StatelessWidget {
  const CategoryAdd({
    super.key,
  });
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
            key: transactionProvider.formkey2,
            child: Consumer2<AddCategoryProvider, AddTransactionProvider>(
                builder: (context, categoryValues, transactionValues, _) {
              return TextFormField(
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => transactionValues.newCategoryValidation(
                  value,
                  categoryValues.incomeModelList,
                  categoryValues.expenseModelList,
                  categoryValues.categoryController.text,
                ),
                controller: categoryValues.categoryController,
                decoration: const InputDecoration(
                  labelText: 'Enter new Category',
                ),
              );
            }),
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
              onPressed: () async {
                transactionProvider.newCategoryAdding(
                  context,
                  categoryProvider.categoryController.text,
                );
                await categoryProvider.refresh(context);
                categoryProvider.categoryController.clear();
              },
              child: const Text('Add'),
            )
          ],
        ),
      ],
    );
  }
}
