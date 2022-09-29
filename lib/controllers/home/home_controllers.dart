import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:project/view/home_screen/widgets/showdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/snackbar.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../models/action_type_enum/action_type_enum_model.dart';
import '../../view/add_transaction_screen/add_screen.dart';
import '../../view/home_screen/widgets/bottom_sheet.dart';
import '../../view/transaction_screen/transactions_screen.dart';

class HomeProvider with ChangeNotifier {
  String? name;
  List<TransactionModel> allIncomeTransactionList = [];
  List<TransactionModel> allExpenseTransactionList = [];
  List<TransactionModel> allTransactionList = [];
  double totalIncome = 0;
  double totalExpense = 0;
  double totalBalance = 0;

  Future<void> refresh(context) async {
    await TransactionDbFunction.instance.refresh(context);
    notifyListeners();
  }

  Future getName() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    name = sharedprefs.getString('username').toString();
    notifyListeners();
  }

  void toTransactionScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const TransactionsScreen()),
      ),
    );
  }

  void toAddScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => AddScreen(type: ActionType.addScreen)),
      ),
    );
  }

  void toEditScreen(context, data) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) =>
            AddScreen(model: data, type: ActionType.editScreen)),
      ),
    );
  }

  void options(int index, String key, TransactionModel data, context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      builder: (BuildContext ctx) {
        return BottomShow(
          data: data,
          index: index,
          keyy: key,
        );
      },
    );
  }

  void delete(String keyy, context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return ShowDeleteDialogue(keyy: keyy);
      },
    );
  }

  Future<void> deleted(String keyy, context) async {
    await TransactionDbFunction.instance.deleteTransaction(keyy, context);
    refresh(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar('Deleted'),
    );
  }
}
