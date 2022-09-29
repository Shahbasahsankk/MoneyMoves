import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/text_widget.dart';
import '../../../controllers/home/home_controllers.dart';

class HomeTransactionList extends StatelessWidget {
  const HomeTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return Expanded(
      child: Consumer<HomeProvider>(
        builder: (context, value, _) {
          return value.allTransactionList.isEmpty
              ? Column(
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
                )
              : ListView.separated(
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
                            backgroundImage: value.allTransactionList[index]
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
                                  name: value
                                      .allTransactionList[index].categoryType,
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
        },
      ),
    );
  }
}
