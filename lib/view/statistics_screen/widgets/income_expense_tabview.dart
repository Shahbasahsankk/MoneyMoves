import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/statistics/statistics_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/sizedbox_color_etc.dart';
import '../../../models/statistics/chart_model.dart';
import '../../../models/transaction_model/transaction_model.dart';

class IncomeExpenseTabView extends StatelessWidget {
  const IncomeExpenseTabView({super.key, required this.list});
  final List<TransactionModel> list;
  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<StatisticsProvider>(context,listen: false);
    return provider.chartLogic(list).isNotEmpty
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
                dataSource: provider.chartLogic(list),
                xValueMapper: (ChartData data, _) => data.categoryName,
                yValueMapper: (ChartData data, _) => data.amount,
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
          );
  }
}
