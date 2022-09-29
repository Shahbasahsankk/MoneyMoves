import 'package:flutter/material.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/add_transaction/add_transaction_controller.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/view/add_transaction_screen/widgets/add_or_edit_textformfeild.dart';
import 'package:project/view/add_transaction_screen/widgets/category_type_dropdown.dart';
import 'package:project/view/add_transaction_screen/widgets/transaction_type_dropdown.dart';
import 'package:provider/provider.dart';

import '../../models/action_type_enum/action_type_enum_model.dart';

// ignore: must_be_immutable
class AddScreen extends StatelessWidget {
  ActionType? type;
  TransactionModel? model;

  AddScreen({
    Key? key,
    this.model,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AddTransactionProvider>(context, listen: false);
    provider.amountController.clear();
    provider.dateController.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.screenCheck(type, model);
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: type == ActionType.addScreen
              ? const Text('Add Transaction')
              : const Text('Edit Transaction'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: double.infinity,
          color: const Color(0xff232526),
          child: Form(
            key: provider.formkey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizedboxH90,
                Padding(
                  padding: padding,
                  child: Consumer<AddTransactionProvider>(
                    builder: (context, values, _) {
                      return TransactionTypeDropDown(
                        values: values,
                        type: type,
                      );
                    },
                  ),
                ),
                Consumer2<AddTransactionProvider, AddCategoryProvider>(
                  builder: ((context, transactionValues, categoryValues, _) {
                    return CategoryTypeDropDown(
                      transactionValues: transactionValues,
                      categoryValues: categoryValues,
                      type: type,
                    );
                  }),
                ),
                Consumer<AddTransactionProvider>(builder: (context, values, _) {
                  return AddDetails(
                    validator: (value) => values.amountValidation(value),
                    controller: values.amountController,
                    hintText: 'Type Amount',
                    keyboardType: TextInputType.number,
                  );
                }),
                Consumer<AddTransactionProvider>(builder: (context, values, _) {
                  return AddDetails(
                    validator: (value) => values.dateValidation(value),
                    readonly: true,
                    controller: values.dateController,
                    hintText: 'Select Date',
                    color: Colors.black,
                    iconData: Icons.date_range_outlined,
                    ontap: () => values.datePick(context),
                  );
                }),
                sizedboxH30,
                Center(
                  child: ElevatedButton(
                    onPressed: () => provider.transactionAddOrUpdate(
                      type,
                      model,
                      context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: type == ActionType.addScreen
                        ? const TextsStyles(name: 'Add Transaction')
                        : const TextsStyles(name: 'Update Transaction'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
