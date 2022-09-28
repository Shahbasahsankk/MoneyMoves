import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/sizedbox_color_etc.dart';
import '../../../controllers/add_transaction/add_transaction_controller.dart';
import '../../../models/action_type_enum/action_type_enum_model.dart';

class TransactionTypeDropDown extends StatelessWidget {
  const TransactionTypeDropDown({
    super.key,
    required this.values,
    required this.type,
  });
  final AddTransactionProvider values;
  final ActionType? type;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: contentPadding,
          fillColor: Colors.white,
          filled: true,
          isDense: true,
        ),
        hint: const Text("Select Transaction Type"),
        value: values.transactionType.toString(),
        isDense: true,
        onChanged: (newTransaction) async =>
            await values.newTransaction(newTransaction, type),
        items: <String>[
          'Income',
          'Expense',
        ].map(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
    );
  }
}
