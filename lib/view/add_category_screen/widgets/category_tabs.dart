import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/sizedbox_color_etc.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
    required this.tabController,
  });
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: TabBar(
        isScrollable: true,
        controller: tabController,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.r),
        ),
        tabs: const [
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
    );
  }
}
