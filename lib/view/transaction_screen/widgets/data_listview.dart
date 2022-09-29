import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/text_widget.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/controllers/transaction/transaction_controller.dart';
import 'package:provider/provider.dart';

class DataListview extends StatelessWidget {
  const DataListview({
    super.key,
    required this.values,
  });
  final TransactionProvider values;
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return values.founData.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              final list = values.founData[index];
              return Padding(
                padding: EdgeInsets.only(left: 13.w, right: 13.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                    onTap: () async {
                      homeProvider.options(
                          index, values.founData[index].id, list, context);
                    },
                    leading: CircleAvatar(
                      backgroundImage: values.founData[index].transactionType ==
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
                        TextsStyles(
                          name: values.founData[index].categoryType,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextsStyles(
                          name: DateFormat('yMMMMd').format(
                            values.founData[index].date,
                          ),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    trailing: TextsStyles(
                      name: '₹${values.founData[index].amount.toString()}',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            itemCount: values.founData.length,
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
                image:
                    AssetImage('lib/assets/no data images/file_not_found.png'),
              ),
              TextsStyles(
                name: 'SORRY. NO RESULTS.',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          );
  }
}
