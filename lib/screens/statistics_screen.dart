import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/db/transaction_db/transaction_db.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Widget_Screens/home_screen_widgets.dart';
import '../models/transaction_model/transaction_model.dart';
import 'chart_sort.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TransactionModel> allData =
      TransactionDbFunction.allTransactionNotifier.value;
  final List<TransactionModel> incomeData =
      TransactionDbFunction.allIncomeTransactionNotifier.value;
  final List<TransactionModel> expenseData =
      TransactionDbFunction.allExpenseTransactionNotifier.value;
  List<TransactionModel> founData = [];
  late TabController tabController;
  @override
  void initState() {
    founData = allData;
    TransactionDbFunction.instance.refresh();
    tabController = TabController(
      length: 3,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        drawer: const SidebarMenu(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Statistics'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ),
        body: Container(
          height: double.infinity.h,
          width: double.infinity.w,
          color: const Color(0xff232526),
          child: Column(
            children: [
              const SizedBox(height: 70,),
              Flexible(
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  tabs: const [
                    Tab(
                      child: TextsStyles(
                        name: 'Overview',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Tab(
                      child: TextsStyles(
                        name: 'Income',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Tab(
                      child: TextsStyles(
                        name: 'Expense',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              sizedboxH20,
              Expanded(
                flex: 2,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    chartLogic(allData).isNotEmpty
                        ? SfCircularChart(
                            legend: Legend(
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              isResponsive: true,
                              isVisible: true,
                            ),
                            series: <CircularSeries>[
                              PieSeries<ChartData, String>(
                                dataSource: chartLogic(allData),
                                xValueMapper: (ChartData data, _) =>
                                    data.categoryName,
                                yValueMapper: (ChartData data, _) =>
                                    data.amount,
                                explode: true,
                                legendIconType: LegendIconType.diamond,
                                dataLabelSettings: const DataLabelSettings(
                                  color: Colors.white,
                                  isVisible: true,
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Image(
                                  height: 200.h,
                                  width: 200.w,
                                  image: const AssetImage(
                                      'lib/assets/no data images/empty_chart.png'),
                                ),
                                TextsStyles(
                                  name: 'SORRY. NO DATA FOUND.',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                    chartLogic(incomeData).isNotEmpty
                        ? SfCircularChart(
                            legend: Legend(
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              isResponsive: true,
                              isVisible: true,
                            ),
                            series: <CircularSeries>[
                              PieSeries<ChartData, String>(
                                dataSource: chartLogic(incomeData),
                                xValueMapper: (ChartData data, _) =>
                                    data.categoryName,
                                yValueMapper: (ChartData data, _) =>
                                    data.amount,
                                explode: true,
                                legendIconType: LegendIconType.diamond,
                                dataLabelSettings: const DataLabelSettings(
                                  color: Colors.white,
                                  isVisible: true,
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Image(
                                 height: 200.h,
                                  width: 200.w,
                                  image: const AssetImage(
                                      'lib/assets/no data images/empty_chart.png'),
                                ),
                                TextsStyles(
                                  name: 'SORRY. NO DATA FOUND.',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                    chartLogic(expenseData).isNotEmpty
                        ? SfCircularChart(
                            legend: Legend(
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              isResponsive: true,
                              isVisible: true,
                            ),
                            series: <CircularSeries>[
                              PieSeries<ChartData, String>(
                                dataSource: chartLogic(expenseData),
                                xValueMapper: (ChartData data, _) =>
                                    data.categoryName,
                                yValueMapper: (ChartData data, _) =>
                                    data.amount,
                                explode: true,
                                legendIconType: LegendIconType.diamond,
                                dataLabelSettings: const DataLabelSettings(
                                  color: Colors.white,
                                  isVisible: true,
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Image(
                                 height: 200.h,
                                  width: 200.w,
                                  image: const AssetImage(
                                      'lib/assets/no data images/empty_chart.png'),
                                ),
                                TextsStyles(
                                  name: 'SORRY. NO DATA FOUND.',
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
