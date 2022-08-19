import 'package:flutter/material.dart';
import 'package:project/Models/model_classes.dart';
import 'package:project/Provider/navigation_provier.dart';
import 'package:project/Screens/add_category_screen.dart';
import 'package:project/Screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/home_screen.dart';
import '../Screens/statistics_screen.dart';
import '../Utilities/sizedbox_color_etc.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.value,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String text;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black,
                child: Icon(
                  icon,
                  color: color,
                  size: 30.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  fontSize: 25.sp,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: padding,
        children: [
          SizedBox(
            height: 150.h,
          ),
          buildMenuItem(
            context,
            text: 'Home',
            iconData: Icons.home,
            onClicked: () =>
                selectedItem(context, 0, SidebarNavigationItem.home),
            item: SidebarNavigationItem.home,
          ),
          buildMenuItem(
            context,
            text: 'Categories',
            iconData: Icons.category,
            onClicked: () =>
                selectedItem(context, 1, SidebarNavigationItem.categories),
            item: SidebarNavigationItem.categories,
          ),
          buildMenuItem(
            context,
            text: 'Statistics',
            iconData: Icons.pie_chart,
            onClicked: () =>
                selectedItem(context, 2, SidebarNavigationItem.statistics),
            item: SidebarNavigationItem.statistics,
          ),
          buildMenuItem(
            context,
            text: 'Settings',
            iconData: Icons.settings,
            onClicked: () =>
                selectedItem(context, 3, SidebarNavigationItem.settings),
            item: SidebarNavigationItem.settings,
          ),
          buildMenuItem(context,
              text: 'Share App',
              iconData: Icons.share,
              item: SidebarNavigationItem.share,
              onClicked: () =>
                  selectedItem(context, 4, SidebarNavigationItem.share))
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context,
      {required String text,
      required IconData iconData,
      required SidebarNavigationItem item,
      VoidCallback? onClicked}) {
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;
    const color = Colors.white;

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.white24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      leading: Icon(
        iconData,
        color: color,
        size: 25.sp,
      ),
      title: TextsStyles(
        name: text,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(
      BuildContext context, int index, SidebarNavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(item);

    Navigator.of(context).pop;

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => const HomeScreen()),
          ),
        );
        break;

      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => const AddCategoryScreen()),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => const StatisticsScreen()),
          ),
        );

        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => const SettingsScreen()),
          ),
        );
        break;
      case 4:
        Share.share(
            'MoneyMoves: Finance Manager, Expense and Income Tracker,https://play.google.com/store/apps/details?id=in.moneymoves.project');
        break;
    }
  }
}
