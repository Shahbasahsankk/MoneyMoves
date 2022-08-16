import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:project/models/category_model/category_model.dart';

class CategoryDbFunction {
  static const String categoryDbName = 'DB_Category';
  static final ValueNotifier<List<CategoryModel>> incomeModelNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<CategoryModel>> expenseModelNotifier =
      ValueNotifier([]);

  CategoryDbFunction._instance();
  static CategoryDbFunction instance = CategoryDbFunction._instance();

  factory CategoryDbFunction() {
    return instance;
  }

  Future<void> addCategory(CategoryModel categoryModel) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.put(categoryModel.id, categoryModel);
    refreshUI();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final getAllCategory = await getAllCategories();
    incomeModelNotifier.value.clear();
    expenseModelNotifier.value.clear();
    await Future.forEach(
      getAllCategory,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeModelNotifier.value.add(category);
        } else if (category.type == CategoryType.expense) {
          expenseModelNotifier.value.add(category);
        }
      },
    );
    incomeModelNotifier.notifyListeners();
    expenseModelNotifier.notifyListeners();
  }

  Future<void> deleteCategory(String key) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.delete(key);
    refreshUI();
  }
}
