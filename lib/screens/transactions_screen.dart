import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/db/transaction_db/transaction_db.dart';
import 'package:project/screens/add_screen.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';

import '../models/transaction_model/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String? currentCategory;
  String? currentTransaction;
  bool search = false;
  final padding = EdgeInsets.only(left: 12.w, right: 12.w);
  final List<TransactionModel> allData =
      TransactionDbFunction.allTransactionNotifier.value;
  List<TransactionModel> founData = [];

  @override
  void initState() {
    currentCategory = 'All';
    currentTransaction = 'All';
    TransactionDbFunction.instance.refresh();
    super.initState();
    founData = allData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Transactions'),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity.h,
          width: double.infinity.w,
          color:  const Color(0xff232526),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: search == false
                    ? Padding(
                        key: const Key('1'),
                        padding: padding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      contentPadding: contentPadding,
                                      fillColor: Colors.white70,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DropdownButton<String>(
                                          hint: const Text("Category"),
                                          value: currentCategory,
                                          isDense: true,
                                          onChanged: (newCategory) {
                                            setState(() {
                                              currentCategory = newCategory;
                                              filter();
                                            });
                                          },
                                          items: <String>[
                                            'All',
                                            'Today',
                                            'Last 28 Days',
                                            'This Year',
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                        DropdownButton<String>(
                                          hint: const Text("Transaction "),
                                          value: currentTransaction,
                                          isDense: true,
                                          onChanged: (selectedTransaction) {
                                            setState(() {
                                              currentTransaction =
                                                  selectedTransaction;
                                              filter();
                                            });
                                          },
                                          items: <String>[
                                            'All',
                                            'Income',
                                            'Expense',
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  search = true;
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 40.sp,
                              ),
                            )
                          ],
                        ),
                      )
                    : Padding(
                        key: const Key('2'),
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                        ),
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          autofocus: founData.length > 3 ? true : false,
                          onChanged: (value) => searchFilter(value),
                          decoration: InputDecoration(
                            contentPadding: contentPadding,
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            hintText: 'Search',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  search = false;
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                      ),
              ),
              sizedboxH20,
              Expanded(
                  child: founData.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            final list = founData[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 13.w, right: 13.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 8.w),
                                  onTap: () =>
                                      options(founData[index].id, list),
                                  leading: CircleAvatar(
                                    backgroundImage: founData[index]
                                                .transactionType ==
                                            'Income'
                                        ? const AssetImage(
                                            'lib/assets/expense & income gifs/income.png')
                                        : const AssetImage(
                                            'lib/assets/expense & income gifs/expense.jpg'),
                                    backgroundColor: Colors.white,
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextsStyles(
                                        name: founData[index].categoryType,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      TextsStyles(
                                        name: DateFormat('yMMMMd').format(
                                          founData[index].date,
                                        ),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  trailing: TextsStyles(
                                    name:
                                        '₹${founData[index].amount.toString()}',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: founData.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        )
                      : Column(
                        children: [
                          SizedBox(
                            height: 105.h,
                          ),
                          const Image(
                            image: AssetImage(
                                'lib/assets/no data images/file_not_found.png'),
                          ),
                          TextsStyles(
                            name: 'SORRY. NO RESULTS.',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      )),
            ],
          ),
        ),
      ),
    );
  }

  options(index, TransactionModel data) => showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      builder: (BuildContext ctx) {
        return SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => AddScreen(
                              model: data,
                              type: ActionType.editScreen,
                            )),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit)),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    delete(index);
                  },
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ))
            ],
          ),
        );
      });

  delete(key) => showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: const Text('Delete Transaction?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await TransactionDbFunction.instance.deleteTransaction(key);
                  WidgetsBinding.instance.addPostFrameCallback((_) => setState(filter)); 
                  if (!mounted) {}
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar('Deleted'),
                  );
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              )
            ],
          );
        },
      );

  void filter() {
    List<TransactionModel> results = [];
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

    setState(() {
      founData = results;
    });
  }

  void searchFilter(String searchKey) {
    List<TransactionModel> results = [];
    if (searchKey.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where((element) => element.categoryType
              .toLowerCase()
              .contains(searchKey.toLowerCase()))
          .toList();
    }
    setState(() {
      founData = results;
    });
  }
}
