import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/db/category_db/category_db.dart';
import 'package:project/models/category_model/category_model.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';
import 'package:project/widget_screens/add_screen_widgets.dart';

import '../db/transaction_db/transaction_db.dart';

enum ActionType { addScreen, editScreen }

// ignore: must_be_immutable
class AddScreen extends StatefulWidget {
  ActionType? type;
  TransactionModel? model;

  AddScreen({Key? key, this.model, this.type}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

String? currentSelectedCategory;
final padding = EdgeInsets.only(left: 20.w, right: 20.w, top: 9.h, bottom: 9.h);

class _AddScreenState extends State<AddScreen> {
  CategoryModel? category;
  String? transactionType;
  DateTime date = DateTime.now();
  DateTime? pickedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  String? hint;

  @override
  void initState() {
    if (widget.type == ActionType.editScreen) {
      currentSelectedCategory = null;
      _dateController.text = DateFormat('yMMMMd').format(widget.model!.date);
      _amountController.text = widget.model!.amount.toString();
      transactionType = widget.model!.transactionType;
      hint = widget.model!.categoryType;
    } else {
      transactionType = 'Income';
      currentSelectedCategory = null;
    }
    CategoryDbFunction().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            key: _formkey1,
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
                      value: transactionType.toString(),
                      isDense: true,
                      onChanged: (newTransaction) {
                        setState(() {
                          transactionType = newTransaction;
                          currentSelectedCategory = null;
                          widget.type == ActionType.editScreen
                              ? hint = "Select Category"
                              : currentSelectedCategory = null;
                        });
                      },
                      items: <String>[
                        'Income',
                        'Expense',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: CategoryDbFunction.incomeModelNotifier,
                  builder: ((BuildContext context, List<CategoryModel> value,
                      Widget? child) {
                    return Padding(
                      padding: padding,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                widget.type == ActionType.addScreen) {
                              return 'Category Type Not Selected';
                            } else if (hint == "Select Category" &&
                                widget.type == ActionType.editScreen) {
                              return 'Category Type Not Selected';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                addCategory();
                              },
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
                                : hint,
                            hintStyle: TextStyle(
                              color: widget.type == ActionType.addScreen
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          value: currentSelectedCategory,
                          isDense: true,
                          onChanged: (newCategory) {
                            hint = newCategory;
                            setState(() {
                              currentSelectedCategory = newCategory;
                            });
                          },
                          items: transactionType == 'Income'
                              ? CategoryDbFunction.incomeModelNotifier.value
                                  .map(
                                    (model) => DropdownMenuItem<String>(
                                      onTap: () {
                                        category = model;
                                      },
                                      value: model.id.toString(),
                                      child: Text(model.name),
                                    ),
                                  )
                                  .toList()
                              : CategoryDbFunction.expenseModelNotifier.value
                                  .map(
                                    (model) => DropdownMenuItem<String>(
                                      onTap: () {
                                        category = model;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter An Amount';
                    } else {
                      return null;
                    }
                  },
                  controller: _amountController,
                  hintText: 'Type Amount',
                  keyboardType: TextInputType.number,
                ),
                AddDetails(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date Not Selected';
                    } else {
                      return null;
                    }
                  },
                  readonly: true,
                  controller: _dateController,
                  hintText: 'Select Date',
                  color: Colors.black,
                  iconData: Icons.date_range_outlined,
                  ontap: () async {
                    pickedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yMMMMd').format(pickedDate!);
                      });
                    }
                  },
                ),
                sizedboxH30,
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? name;
                      if (currentSelectedCategory == null &&
                          widget.type == ActionType.editScreen) {
                        name = widget.model!.categoryType;
                      } else if (currentSelectedCategory != null &&
                          widget.type == ActionType.editScreen) {
                        name = category!.name;
                      }
                      if (_formkey1.currentState!.validate()) {
                        final value = double.tryParse(_amountController.text);
                        pickedDate ??= widget.model!.date;
                        final transaction = TransactionModel(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          transactionType: transactionType!,
                          categoryType: widget.type == ActionType.editScreen
                              ? name!
                              : category!.name,
                          amount: value!,
                          date: pickedDate!,
                        );
                        if (widget.type == ActionType.addScreen) {
                          await TransactionDbFunction()
                              .addTransaction(transaction);
                        } else {
                          widget.model!.updateTransaction(transaction);
                        }
                        if (!mounted) {}
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(widget.type == ActionType.addScreen
                              ? 'Transaction Added'
                              : 'Transaction Updated'),
                        );
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const HomeScreen()),
                            ),
                            (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
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

  addCategory() => showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: const Text('New Category'),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 23.w, right: 23.w),
                child: Form(
                  key: _formkey2,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (transactionType == 'Income') {
                        final income = CategoryDbFunction
                            .incomeModelNotifier.value
                            .map((e) => e.name.trim().toLowerCase())
                            .toList();
                        if (income.contains(
                            _categoryController.text.trim().toLowerCase())) {
                          return 'Category Already Exists';
                        }
                      }
                      if (transactionType == 'Expense') {
                        final expense = CategoryDbFunction
                            .expenseModelNotifier.value
                            .map((e) => e.name.trim().toLowerCase())
                            .toList();
                        if (expense.contains(
                            _categoryController.text.trim().toLowerCase())) {
                          return 'Category Already Exists';
                        }
                      }
                      if (value == '' || value == null) {
                        return 'Not Filled';
                      } else {
                        return null;
                      }
                    },
                    maxLength: 10,
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Enter new Category',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _categoryController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formkey2.currentState!.validate()) {
                        final category = CategoryModel(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          type: transactionType == 'Income'
                              ? CategoryType.income
                              : CategoryType.expense,
                          name: _categoryController.text,
                        );
                        await CategoryDbFunction.instance.addCategory(category);

                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                        _categoryController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar('Category Added'),
                        );
                      }
                    },
                    child: const Text('Add'),
                  )
                ],
              ),
            ],
          ));
}
