import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/controllers/statistics/statistics_controller.dart';
import 'package:project/view/statistics_screen/widgets/income_expense_tabview.dart';
import 'package:project/view/statistics_screen/widgets/tab_views.dart';
import 'package:project/view/statistics_screen/widgets/tabs.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigation/sidebar_controller.dart';
import '../sidabar_menu/sidebar_drawer.dart';

// ignore: must_be_immutable
class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key? key}) : super(key: key);

  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    final provider = Provider.of<StatisticsProvider>(context, listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await homeProvider.refresh(context);
      provider.allData = homeProvider.allTransactionList;
      provider.incomeData = homeProvider.allIncomeTransactionList;
      provider.expenseData = homeProvider.allExpenseTransactionList;
      provider.founData = provider.allData;
    });
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        drawer: const SidebarMenu(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Statistics'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => navigationProvider.openSideBar(scaffoldKey),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ),
        body: Builder(builder: (context) {
          tabController = TabController(
            length: 3,
            vsync: Scaffold.of(context),
          );
          return Container(
            height: double.infinity.h,
            width: double.infinity.w,
            color: const Color(0xff232526),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 10.h,
                bottom: 10.h,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  StatisticsTab(tabController: tabController),
                  sizedboxH20,
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        OverViewTabView(list: provider.allData),
                        IncomeExpenseTabView(list: provider.incomeData),
                        IncomeExpenseTabView(list: provider.expenseData),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
