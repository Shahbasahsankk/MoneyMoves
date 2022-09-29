import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/snackbar.dart';
import '../../db/category_db/category_db.dart';
import '../../models/category_model/category_model.dart';
import '../../view/add_category_screen/widgets/add_category.dart';
import '../../view/add_category_screen/widgets/delete_category.dart';
import '../../view/add_category_screen/widgets/delete_dailogue.dart';

class AddCategoryProvider with ChangeNotifier {
  TextEditingController categoryController = TextEditingController();
  final List<CategoryModel> incomeModelList = [];
  final List<CategoryModel> expenseModelList = [];
  List<CategoryModel> modelList = [];

  Future<void> refresh(context) async {
    await CategoryDbFunction().refreshUI(context);
    notifyListeners();
  }

  void bottomDeleteShow(String key, context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      builder: (ctx) {
        return BottomDeleteCategory(
          keyy: key,
        );
      },
    );
  }

  void deleteDailogue(context, key) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return DeleteDailogue(keyy: key);
      },
    );
  }

  Future<void> deleteCategory(context, keyy) async {
    await CategoryDbFunction.instance.deleteCategory(keyy, context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar('Deleted'),
    );
    refresh(context);
  }

  void categoryShow(context, formkey, tabController) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCategory(
          formkey: formkey,
          tabController: tabController,
        );
      },
    );
  }

  String? addCategoryValidation(tabController, value) {
    if (tabController.index == 0) {
      final income =
          incomeModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (income.contains(categoryController.text.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    }
    if (tabController.index == 1) {
      final expense =
          expenseModelList.map((e) => e.name.trim().toLowerCase()).toList();
      if (expense.contains(categoryController.text.trim().toLowerCase())) {
        return 'Category Already Exists';
      }
    }
    if (value == '' || value == null) {
      return 'Not Filled';
    } else {
      return null;
    }
  }

  Future<void> categoryAdded(currentState, tabController, context) async {
    if (currentState.validate()) {
      final category = CategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: tabController.index == 0
            ? CategoryType.income
            : CategoryType.expense,
        name: categoryController.text,
      );
      await CategoryDbFunction.instance.addCategory(category, context);
      categoryController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('Category Added'),
      );
      notifyListeners();
    }
  }

  void modelListChecking(dynamic list) {
    if (list == incomeModelList) {
      modelList = incomeModelList;
    } else {
      modelList = expenseModelList;
    }
    notifyListeners();
  }
}
