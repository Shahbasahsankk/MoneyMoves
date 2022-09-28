import 'package:flutter/material.dart';
import 'package:project/models/statistics/chart_model.dart';

import '../../models/transaction_model/transaction_model.dart';

class StatisticsProvider with ChangeNotifier {
  List<TransactionModel> allData = [];
  List<TransactionModel> incomeData = [];
  List<TransactionModel> expenseData = [];
  List<TransactionModel> founData = [];

  loadData(List<TransactionModel> allList, List<TransactionModel> incomeList,
      List<TransactionModel> expenseList) {
    allData = allList;
    incomeData = incomeList;
    expenseData = expenseList;
    founData = allData;
    notifyListeners();
  }

  List<ChartData> chartLogic(List<TransactionModel> list) {
    List visited = [];
    List<ChartData> returnData = [];
    int value;
    String categoryName;
    for (var i = 0; i < list.length; i++) {
      visited.add(0);
    }
    for (var i = 0; i < list.length; i++) {
      value = list[i].amount.toInt();
      categoryName = list[i].categoryType;
      for (var j = i + 1; j < list.length; j++) {
        if (categoryName == list[j].categoryType) {
          value += list[j].amount.toInt();
          visited[j] = -1;
        }
      }
      if (visited[i] != -1) {
        returnData.add(ChartData(value, categoryName));
      }
    }
    return returnData;
  }

  List<ChartData> overViewChartLogic(List<TransactionModel> list) {
    List visited = [];
    List<ChartData> returnData = [];
    int value;
    String transactionName;
    for (var i = 0; i < list.length; i++) {
      visited.add(0);
    }
    for (var i = 0; i < list.length; i++) {
      value = list[i].amount.toInt();
      transactionName = list[i].transactionType;
      for (var j = i + 1; j < list.length; j++) {
        if (transactionName == list[j].transactionType) {
          value += list[j].amount.toInt();
          visited[j] = -1;
        }
      }
      if (visited[i] != -1) {
        returnData.add(ChartData(value, transactionName));
      }
    }
    return returnData;
  }
}
