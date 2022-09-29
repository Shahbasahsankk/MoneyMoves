import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/text_widget.dart';
import '../../../controllers/home/home_controllers.dart';
import 'income_expense_circleavatar.dart';

class HomeBox extends StatelessWidget {
  const HomeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9.w,
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
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
                name: value.totalBalance < 0 ? 'Total Loss' : 'Total Balance',
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
              padding:
                  EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<HomeProvider>(builder: (context, value, _) {
                    return IncomeExpense(
                      color: Colors.green,
                      icon: Icons.arrow_upward,
                      text: 'Income',
                      value: '${value.totalIncome.round()}',
                    );
                  }),
                  Consumer<HomeProvider>(builder: (context, value, _) {
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
    );
  }
}
