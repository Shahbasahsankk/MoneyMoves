import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/controllers/transaction/transaction_controller.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/view/transaction_screen/widgets/data_listview.dart';
import 'package:project/view/transaction_screen/widgets/search_and_filter_change.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.search = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await homeProvider.refresh(context);
      provider.initialDataSetting(homeProvider.allTransactionList);
    });
    final padding = EdgeInsets.only(left: 12.w, right: 12.w);
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
          color: const Color(0xff232526),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              Consumer<TransactionProvider>(builder: (context, values, _) {
                return SearchAndFilterChange(
                  values: values,
                  pading: padding,
                );
              }),
              sizedboxH20,
              Expanded(
                child: Consumer<TransactionProvider>(
                  builder: (context, values, _) {
                    return DataListview(values: values);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
