import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String transactionType;
  @HiveField(2)
  String categoryType;
  @HiveField(3)
  double amount;
  @HiveField(4)
  DateTime date;

  TransactionModel({
    required this.id,
    required this.transactionType,
    required this.categoryType,
    required this.amount,
    required this.date,
  });

  updateTransaction(TransactionModel update) {
    transactionType = update.transactionType;
    categoryType = update.categoryType;
    amount = update.amount;
    date = update.date;
    save();
  }
}
