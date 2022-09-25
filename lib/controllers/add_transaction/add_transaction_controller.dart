import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/sizedbox_color_etc.dart';
import '../../db/category_db/category_db.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../models/category_model/category_model.dart';
import '../../models/transaction_model/transaction_model.dart';
import '../../view/add_transaction_screen/add_screen.dart';
import '../../view/add_transaction_screen/widgets/add_category_dailogue.dart';
import '../../view/home_screen/home_screen.dart';

class AddTransactionProvider with ChangeNotifier {
  CategoryModel? category;
  String? transactionType;
  String? hint;
  DateTime date = DateTime.now();
  DateTime? pickedDate;
  String? currentSelectedCategory;
  String? name;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  screenCheck(type, model) {
    if (type == ActionType.editScreen) {
      currentSelectedCategory = null;
      dateController.text = DateFormat('yMMMMd').format(model!.date);
      amountController.text = model!.amount.toString();
      transactionType = model!.transactionType;
      hint = model!.categoryType;
      notifyListeners();
    } else {
      transactionType = 'Income';
      currentSelectedCategory = null;
      dateController.clear();
      amountController.clear();
      notifyListeners();
    }
    notifyListeners();
  }

  newTransaction(newTransaction, type) {
    transactionType = newTransaction;
    currentSelectedCategory = null;
    type == ActionType.editScreen
        ? hint = "Select Category"
        : currentSelectedCategory = null;
    notifyListeners();
  }

  categoryValidation(value, type) {
    if ((value == null || value.isEmpty) && type == ActionType.addScreen) {
      return 'Category Type Not Selected';
    } else if (hint == "Select Category" && type == ActionType.editScreen) {
      return 'Category Type Not Selected';
    } else {
      return null;
    }
  }

  amountValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Enter An Amount';
    } else {
      return null;
    }
  }

  dateValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Date Not Selected';
    } else {
      return null;
    }
  }

  datePick(context) async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dateController.text = DateFormat('yMMMMd').format(pickedDate!);
    }
    notifyListeners();
  }

  transactionAddOrUpdate(type, model, formkey1, context) async {
    if (currentSelectedCategory == null && type == ActionType.editScreen) {
      name = model!.categoryType;
    } else if (currentSelectedCategory != null &&
        type == ActionType.editScreen) {
      name = category!.name;
    }
    if (formkey1.currentState!.validate()) {
      final value = double.tryParse(amountController.text);
      pickedDate ??= model!.date;
      final transaction = TransactionModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        transactionType: transactionType!,
        categoryType: type == ActionType.editScreen ? name! : category!.name,
        amount: value!,
        date: pickedDate!,
      );
      if (type == ActionType.addScreen) {
        await TransactionDbFunction().addTransaction(transaction);
      } else {
        model!.updateTransaction(transaction);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(type == ActionType.addScreen
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
  }

  addCategory(context, formkey2) async {
    showDialog(
      context: context,
      builder: (context) {
        return CategoryAdd(formkey2: formkey2);
      },
    );
  }

  newCategoryValidation(
      value, incomeModelList, expenseModelList, controllerText) {
    if (transactionType == 'Income') {
      final income =
          incomeModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (income.contains(controllerText.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    }
    if (transactionType == 'Expense') {
      final expense =
          expenseModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (expense.contains(controllerText.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    }
    if (value == '' || value == null) {
      return 'Not Filled';
    } else {
      return null;
    }
  }

  newCategoryAdding(currentState, categoryControllerText, context) async {
    if (currentState.validate()) {
      final category = CategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: transactionType == 'Income'
            ? CategoryType.income
            : CategoryType.expense,
        name: categoryControllerText,
      );
      await CategoryDbFunction.instance.addCategory(category, context);
      Navigator.pop(context);
      categoryControllerText.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('Category Added'),
      );
      notifyListeners();
    }
  }
}
