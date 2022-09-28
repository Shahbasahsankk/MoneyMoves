import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/sizedbox_color_etc.dart';
import '../../db/category_db/category_db.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../models/action_type_enum/action_type_enum_model.dart';
import '../../models/category_model/category_model.dart';
import '../../models/transaction_model/transaction_model.dart';
import '../../view/add_transaction_screen/widgets/add_category_dailogue.dart';
import '../../view/home_screen/home_screen.dart';

class AddTransactionProvider with ChangeNotifier {
  CategoryModel? category;
  String transactionType = 'Income';
  String? hint;
  DateTime date = DateTime.now();
  DateTime? pickedDate;
  String? currentSelectedCategory;
  String? name;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final formkey2 = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();

  screenCheck(type, TransactionModel? model) {
    if (type == ActionType.editScreen) {
      currentSelectedCategory = null;
      dateController.text = DateFormat('yMMMMd').format(model!.date);
      amountController.text = model.amount.toString();
      transactionType = model.transactionType;
      hint = model.categoryType;
    } else {
      currentSelectedCategory = null;
      dateController.clear();
      amountController.clear();
      transactionType = 'Income';
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

  categoryValidation(String? value, type) {
    if ((value == null || value.isEmpty) && type == ActionType.addScreen) {
      return 'Category Type Not Selected';
    } else if (hint == "Select Category" && type == ActionType.editScreen) {
      return 'Category Type Not Selected';
    } else {
      return null;
    }
  }

  amountValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter An Amount';
    } else {
      return null;
    }
  }

  dateValidation(String? value) {
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

  transactionAddOrUpdate(type, TransactionModel? model, context) async {
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
        transactionType: transactionType,
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

  addCategory(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const CategoryAdd();
      },
    );
  }

  newCategoryValidation(value, List<CategoryModel> incomeModelList,
      List<CategoryModel> expenseModelList, String text) {
    if (value == '' || value == null) {
      return 'Not Filled';
    }
    if (transactionType == 'Income') {
      final income =
          incomeModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (income.contains(text.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    }
    if (transactionType == 'Expense') {
      final expense =
          expenseModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (expense.contains(text.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    } else {
      return null;
    }
  }

  newCategoryAdding(context, text) async {
    if (formkey2.currentState!.validate()) {
      final category = CategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: transactionType == 'Income'
            ? CategoryType.income
            : CategoryType.expense,
        name: text,
      );
      await CategoryDbFunction.instance.addCategory(category, context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('Category Added'),
      );
      notifyListeners();
    }
  }
}
