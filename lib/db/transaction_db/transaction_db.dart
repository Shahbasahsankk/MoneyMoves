import 'package:hive_flutter/hive_flutter.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:provider/provider.dart';

class TransactionDbFunction {
  static const String transactionDbName = 'DB_Transaction';

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

  Future<void> deleteTransaction(String key, context) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.delete(key);
    refresh(context);
  }

  Future<void> refresh(context) async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    provider.allTransactionList.clear();
    provider.allTransactionList.addAll(allTransaction);
    provider.allIncomeTransactionList.clear();
    provider.allExpenseTransactionList.clear();

    provider.totalIncome = 0;
    provider.totalExpense = 0;
    provider.totalBalance = 0;
    await Future.forEach(
      allTransaction,
      (TransactionModel transaction) {
        provider.totalBalance = provider.totalBalance + transaction.amount;
        if (transaction.transactionType == 'Income') {
          provider.allIncomeTransactionList.add(transaction);
          provider.totalIncome = provider.totalIncome + transaction.amount;
        } else {
          provider.allExpenseTransactionList.add(transaction);
          provider.totalExpense = provider.totalExpense + transaction.amount;
        }
      },
    );
    provider.totalBalance = provider.totalIncome - provider.totalExpense;
  }
}
