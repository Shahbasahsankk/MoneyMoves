
import 'package:hive/hive.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/models/category_model/category_model.dart';
import 'package:provider/provider.dart';

class CategoryDbFunction {
  static const String categoryDbName = 'DB_Category';
  CategoryDbFunction._instance();
  static CategoryDbFunction instance = CategoryDbFunction._instance();

  factory CategoryDbFunction() {
    return instance;
  }

  Future<void> addCategory(CategoryModel categoryModel,context) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.put(categoryModel.id, categoryModel);
    refreshUI(context);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI(context) async {
    final provider= Provider.of<AddCategoryProvider>(context,listen:false);
    final getAllCategory = await getAllCategories();
    provider.incomeModelList.clear();
    provider.expenseModelList.clear();
    await Future.forEach(
      getAllCategory,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          provider.incomeModelList.add(category);
        } else if (category.type == CategoryType.expense) {
          provider.expenseModelList.add(category);
        }
      },
    );
  }

  Future<void> deleteCategory(String key,context) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.delete(key);
    refreshUI(context);
  }
}
