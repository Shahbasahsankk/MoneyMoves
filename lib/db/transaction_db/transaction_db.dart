import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
class TransactionDbFunction {
  static const String transactionDbName = 'DB_Transaction';

  static final ValueNotifier<List<TransactionModel>>
      allIncomeTransactionNotifier = ValueNotifier([]);

  static final ValueNotifier<List<TransactionModel>>
      allExpenseTransactionNotifier = ValueNotifier([]);

  static final ValueNotifier<List<TransactionModel>> allTransactionNotifier =
      ValueNotifier([]);

  ValueNotifier<num> totalIncome = ValueNotifier(0);
  ValueNotifier<num> totalExpense = ValueNotifier(0);
  ValueNotifier<num> totalBalance = ValueNotifier(0);

  TransactionDbFunction._internal();
  static TransactionDbFunction instance = TransactionDbFunction._internal();

  factory TransactionDbFunction() {
    return instance;
  }

  Future<void> addTransaction(TransactionModel transactionModel) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.put(transactionModel.id, transactionModel);
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDB.values.toList();
  }

  Future<void> deleteTransaction(String key) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.delete(key);
    refresh();
  }

  Future<void> refresh() async {
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    allTransactionNotifier.value.clear();
    allTransactionNotifier.value.addAll(allTransaction);
    allTransactionNotifier.notifyListeners();
    allIncomeTransactionNotifier.value.clear();
    allExpenseTransactionNotifier.value.clear();
    totalIncome.value = 0;
    totalExpense.value = 0;
    totalBalance.value = 0;
    await Future.forEach(
      allTransaction,
      (TransactionModel transaction) {
        totalBalance.value = totalBalance.value + transaction.amount;
        if (transaction.transactionType == 'Income') {
          allIncomeTransactionNotifier.value.add(transaction);
          totalIncome.value = totalIncome.value + transaction.amount;
        } else {
          allExpenseTransactionNotifier.value.add(transaction);
          totalExpense.value = totalExpense.value + transaction.amount;
        }
      },
    );
    totalBalance.value = totalIncome.value - totalExpense.value;
    allIncomeTransactionNotifier.notifyListeners();
    allExpenseTransactionNotifier.notifyListeners();
    totalIncome.notifyListeners();
    totalExpense.notifyListeners();
    totalBalance.notifyListeners();
  }
}
