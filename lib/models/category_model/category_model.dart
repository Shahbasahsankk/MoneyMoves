import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final CategoryType type;
  @HiveField(2)
  final bool isDeleted;
  @HiveField(3)
  final String name;

  CategoryModel(
      {required this.id,
      required this.type,
      this.isDeleted = false,
      required this.name});
}
