import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/add_transaction/add_transaction_controller.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/view/add_transaction_screen/widgets/add_or_edit_textformfeild.dart';
import 'package:provider/provider.dart';

enum ActionType { addScreen, editScreen }

// ignore: must_be_immutable
class AddScreen extends StatefulWidget {
  ActionType? type;
  TransactionModel? model;

  AddScreen({Key? key, this.model, this.type}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

final padding = EdgeInsets.only(left: 20.w, right: 20.w, top: 9.h, bottom: 9.h);

class _AddScreenState extends State<AddScreen> {
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AddTransactionProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<AddCategoryProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryProvider.refresh(context);
      provider.screenCheck(widget.type, widget.model);
    });

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: widget.type == ActionType.addScreen
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
            key: formkey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sizedboxH90,
                Padding(
                  padding: padding,
                  child: DropdownButtonHideUnderline(
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
                    value: provider.transactionType.toString(),
                    isDense: true,
                    onChanged: (newTransaction) async => await provider
                        .newTransaction(newTransaction, widget.type),
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
                  )),
                ),
                Consumer<AddCategoryProvider>(
                  builder: ((context, values, _) {
                    return Padding(
                      padding: padding,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              provider.categoryValidation(value, widget.type),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () async => await provider.addCategory(
                                context,
                                formkey2,
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
                            hintText: widget.type == ActionType.addScreen
                                ? "Select Category"
                                : provider.hint,
                            hintStyle: TextStyle(
                              color: widget.type == ActionType.addScreen
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          value: provider.currentSelectedCategory,
                          isDense: true,
                          onChanged: (newCategory) {
                            provider.hint = newCategory;
                            provider.currentSelectedCategory = newCategory;
                          },
                          items: provider.transactionType == 'Income'
                              ? values.incomeModelList
                                  .map(
                                    (model) => DropdownMenuItem<String>(
                                      onTap: () {
                                        provider.category = model;
                                      },
                                      value: model.id.toString(),
                                      child: Text(model.name),
                                    ),
                                  )
                                  .toList()
                              : values.expenseModelList
                                  .map(
                                    (model) => DropdownMenuItem<String>(
                                      onTap: () {
                                        provider.category = model;
                                      },
                                      value: model.id.toString(),
                                      child: Text(model.name),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    );
                  }),
                ),
                AddDetails(
                  validator: (value) => provider.amountValidation(value),
                  controller: provider.amountController,
                  hintText: 'Type Amount',
                  keyboardType: TextInputType.number,
                ),
                AddDetails(
                  validator: (value) => provider.dateValidation(value),
                  readonly: true,
                  controller: provider.dateController,
                  hintText: 'Select Date',
                  color: Colors.black,
                  iconData: Icons.date_range_outlined,
                  ontap: () => provider.datePick(context),
                ),
                sizedboxH30,
                Center(
                  child: ElevatedButton(
                    onPressed: () => provider.transactionAddOrUpdate(
                      widget.type,
                      widget.model,
                      formkey1,
                      context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: widget.type == ActionType.addScreen
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
