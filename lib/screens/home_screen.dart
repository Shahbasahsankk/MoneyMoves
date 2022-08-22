import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/Screens/transactions_screen.dart';
import 'package:project/screens/add_screen.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget_Screens/home_screen_widgets.dart';
import '../db/transaction_db/transaction_db.dart';
import '../models/transaction_model/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = '';
  @override
  void initState() {
    getName();
    TransactionDbFunction.instance.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: const SidebarMenu(),
          body: Container(
           color:  const Color(0xff232526),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                      sizedboxW15,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextsStyles(
                              fontSize: 18.sp,
                              name: 'Welcome',
                              color: Colors.blue,
                            ),
                            TextsStyles(
                              fontSize: 25.sp,
                              name: name,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9.w,
                  margin: EdgeInsets.only(
                      left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable:
                                TransactionDbFunction.instance.totalBalance,
                            builder: (BuildContext context, num value,
                                Widget? child) {
                              return TextsStyles(
                                name:
                                    value < 0 ? 'Total Loss' : 'Total Balance',
                                textAlign: TextAlign.center,
                                fontSize: 20.sp,
                                color: Colors.black,
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextsStyles(
                              name: '₹',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            ValueListenableBuilder(
                                valueListenable:
                                    TransactionDbFunction.instance.totalBalance,
                                builder: (BuildContext context, num value,
                                    Widget? child) {
                                  return FittedBox(
                                    child: TextsStyles(
                                      name: '${value.round().abs()}',
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors.black ,
                                    ),
                                  );
                                }),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable:
                                    TransactionDbFunction.instance.totalIncome,
                                builder: (BuildContext context, num value,
                                    Widget? child) {
                                  return IncomeExpense(
                                    color: Colors.green,
                                    icon: Icons.arrow_upward,
                                    text: 'Income',
                                    value: '${value.round()}',
                                  );
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    TransactionDbFunction.instance.totalExpense,
                                builder: (BuildContext context, num value,
                                    Widget? child) {
                                  return IncomeExpense(
                                    color: Colors.red,
                                    icon: Icons.arrow_downward_outlined,
                                    text: 'Expense',
                                    value: '${value.round()}',
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextsStyles(
                        name: 'RECENT  TRANSACTIONS',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) =>
                                  const TransactionsScreen()),
                            ),
                          );
                        },
                        child: TextsStyles(
                          name: 'View All',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable:
                        TransactionDbFunction.allTransactionNotifier,
                    builder: (BuildContext context,
                        List<TransactionModel> newList, Widget? child) {
                      if (newList.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            TextsStyles(
                              name: 'SORRY. NO RESULTS.',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            const Image(
                              image: AssetImage(
                                  'lib/assets/no data images/file_not_found.png'),
                            ),
                          ],
                        );
                      } else {
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            final data = newList[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 13.w, right: 13.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: ListTile(
                                  onTap: () => options(newList[index].id, data),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 8.w),
                                  leading: CircleAvatar(
                                    backgroundImage: newList[
                                                    index]
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
                                      FittedBox(
                                        child: TextsStyles(
                                          name: newList[index].categoryType,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      TextsStyles(
                                        name: DateFormat('yMMMMd').format(
                                          newList[index].date,
                                        ),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  trailing: TextsStyles(
                                    name:
                                        '₹${newList[index].amount.toString()}',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: newList.length >= 4 ? 4 : newList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => AddScreen(type: ActionType.addScreen)),
                ),
              );
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 40.sp,
            ),
          )),
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

  Future getName() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    setState(() {
      name = sharedprefs.getString('username').toString();
    });
  }
}
