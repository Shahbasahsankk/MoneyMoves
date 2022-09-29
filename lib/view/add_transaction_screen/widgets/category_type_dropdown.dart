import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/sizedbox_padding_etc.dart';
import '../../../controllers/add_category/add_category_controller.dart';
import '../../../controllers/add_transaction/add_transaction_controller.dart';
import '../../../models/action_type_enum/action_type_enum_model.dart';

class CategoryTypeDropDown extends StatelessWidget {
  const CategoryTypeDropDown({
    super.key,
    required this.transactionValues,
    required this.type,
    required this.categoryValues,
  });
  final AddTransactionProvider transactionValues;
  final AddCategoryProvider categoryValues;
  final ActionType? type;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await categoryValues.refresh(context);
    });
    return Padding(
      padding: padding,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              transactionValues.categoryValidation(value, type),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () async => await transactionValues.addCategory(
                context,
              ),
              child: Icon(
                Icons.add_box_rounded,
                color: Colors.blue,
                size: 30.sp,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            contentPadding: contentPadding,
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            hintText: type == ActionType.addScreen
                ? "Select Category"
                : transactionValues.hint,
            hintStyle: TextStyle(
              color: type == ActionType.addScreen ? Colors.grey : Colors.black,
            ),
          ),
          value: transactionValues.currentSelectedCategory,
          isDense: true,
          onChanged: (newCategory) {
            transactionValues.hint = newCategory;
            transactionValues.currentSelectedCategory = newCategory;
          },
          items: transactionValues.transactionType == 'Income'
              ? categoryValues.incomeModelList
                  .map(
                    (model) => DropdownMenuItem<String>(
                      onTap: () {
                        transactionValues.category = model;
                      },
                      value: model.id.toString(),
                      child: Text(model.name),
                    ),
                  )
                  .toList()
              : categoryValues.expenseModelList
                  .map(
                    (model) => DropdownMenuItem<String>(
                      onTap: () {
                        transactionValues.category = model;
                      },
                      value: model.id.toString(),
                      child: Text(model.name),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
