import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/transaction_model/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  String? currentCategory;
  String? currentTransaction;
  bool search = false;
  List<TransactionModel> allData = [];
  List<TransactionModel> founData = [];
  List<TransactionModel> results = [];

  void categoryChange(newCategory) {
    currentCategory = newCategory;
    filter();
    notifyListeners();
  }

  void initialDataSetting(List<TransactionModel> allTransactionList) async {
    allData = allTransactionList;
    founData = allData;
    currentCategory = 'All';
    currentTransaction = 'All';
    notifyListeners();
  }

  void transactionChange(selectedTransaction) {
    currentTransaction = selectedTransaction;
    filter();
    notifyListeners();
  }

  void filter() {
    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    final monthDate = DateTime.now().subtract(const Duration(days: 28));
    final yearDate = DateTime.now().subtract(const Duration(days: 365));
    if (currentCategory == 'All' && currentTransaction == 'All') {
      results = allData;
    } else if (currentCategory == 'All' && currentTransaction == 'Income') {
      results = allData
          .where((element) => element.transactionType == 'Income')
          .toList();
    } else if (currentCategory == 'All' && currentTransaction == 'Expense') {
      results = allData
          .where((element) => element.transactionType == 'Expense')
          .toList();
    } else if (currentCategory == 'Today' && currentTransaction == 'All') {
      results =
          allData.where((element) => element.date == parsedTodayDate).toList();
    } else if (currentCategory == 'Today' && currentTransaction == 'Income') {
      results = allData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.transactionType == 'Income')
          .toList();
    } else if (currentCategory == 'Today' && currentTransaction == 'Expense') {
      results = allData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.transactionType == 'Expense')
          .toList();
    } else if (currentCategory == 'Last 28 Days' &&
        currentTransaction == 'All') {
      results =
          allData.where((element) => element.date.isAfter(monthDate)).toList();
    } else if (currentCategory == 'Last 28 Days' &&
        currentTransaction == 'Income') {
      results = allData
          .where((element) =>
              element.date.isAfter(monthDate) &&
              element.transactionType == 'Income')
          .toList();
    } else if (currentCategory == 'Last 28 Days' &&
        currentTransaction == 'Expense') {
      results = allData
          .where((element) =>
              element.date.isAfter(monthDate) &&
              element.transactionType == 'Expense')
          .toList();
    } else if (currentCategory == 'This Year' && currentTransaction == 'All') {
      results =
          allData.where((element) => element.date.isAfter(yearDate)).toList();
    } else if (currentCategory == 'This Year' &&
        currentTransaction == 'Income') {
      results = allData
          .where((element) =>
              element.date.isAfter(yearDate) &&
              element.transactionType == 'Income')
          .toList();
    } else if (currentCategory == 'This Year' &&
        currentTransaction == 'Expense') {
      results = allData
          .where((element) =>
              element.date.isAfter(yearDate) &&
              element.transactionType == 'Expense')
          .toList();
    }
    founData = results;
    notifyListeners();
  }

  void searchChange(value) {
    if (value == true) {
      search = true;
    } else {
      search = false;
      searchFilter('');
    }
    notifyListeners();
  }

  void searchFilter(String searchKey) {
    if (searchKey.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where((element) => element.categoryType
              .toLowerCase()
              .contains(searchKey.toLowerCase()))
          .toList();
    }
    founData = results;
    notifyListeners();
  }
}
