import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/view/home_screen/widgets/income_expense_circleavatar.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigation/sidebar_controller.dart';
import '../../models/sidebar/enum_sidebar.dart';
import '../sidabar_menu/sidebar_drawer.dart';
import '../transaction_screen/transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      navigationProvider.setNavigationItem(SidebarNavigationItem.home);
      provider.getName();
      await provider.refresh(context);
    });
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const SidebarMenu(),
        body: Container(
          color: const Color(0xff232526),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => navigationProvider.openSideBar(scaffoldKey),
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
                          Consumer<HomeProvider>(builder: (context, value, _) {
                            return TextsStyles(
                              fontSize: 25.sp,
                              name: value.name ?? '',
                              color: Colors.white,
                            );
                          })
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
                      Consumer<HomeProvider>(builder: (context, value, _) {
                        return TextsStyles(
                          name: value.totalBalance < 0
                              ? 'Total Loss'
                              : 'Total Balance',
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
                          Consumer<HomeProvider>(builder: (context, value, _) {
                            return FittedBox(
                              child: TextsStyles(
                                name: '${value.totalBalance.round().abs()}',
                                fontSize: 35.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                            Consumer<HomeProvider>(
                                builder: (context, value, _) {
                              return IncomeExpense(
                                color: Colors.green,
                                icon: Icons.arrow_upward,
                                text: 'Income',
                                value: '${value.totalIncome.round()}',
                              );
                            }),
                            Consumer<HomeProvider>(
                                builder: (context, value, _) {
                              return IncomeExpense(
                                color: Colors.red,
                                icon: Icons.arrow_downward_outlined,
                                text: 'Expense',
                                value: '${value.totalExpense.round()}',
                              );
                            }),
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
                            builder: ((context) => const TransactionsScreen()),
                          ),
                        );
                      },
                      //  provider.toTransactionScreen(context),
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
                child: Consumer<HomeProvider>(
                  builder: (context, value, _) {
                    if (value.allTransactionList.isEmpty) {
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
                          final data = value.allTransactionList[index];
                          return Padding(
                            padding: EdgeInsets.only(left: 13.w, right: 13.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: ListTile(
                                onTap: () => provider.options(
                                  index,
                                  value.allTransactionList[index].id,
                                  data,
                                  context,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 8.w),
                                leading: CircleAvatar(
                                  backgroundImage: value
                                              .allTransactionList[index]
                                              .transactionType ==
                                          'Income'
                                      ? const AssetImage(
                                          'lib/assets/expense & income gifs/income.png')
                                      : const AssetImage(
                                          'lib/assets/expense & income gifs/expense.jpg'),
                                  backgroundColor: Colors.white,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: TextsStyles(
                                        name: value.allTransactionList[index]
                                            .categoryType,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    TextsStyles(
                                      name: DateFormat('yMMMMd').format(
                                        value.allTransactionList[index].date,
                                      ),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                trailing: TextsStyles(
                                  name:
                                      '₹${value.allTransactionList[index].amount.toString()}',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: value.allTransactionList.length >= 4
                            ? 4
                            : value.allTransactionList.length,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => provider.toAddScreen(context),
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 40.sp,
          ),
        ),
      ),
    );
  }
}
