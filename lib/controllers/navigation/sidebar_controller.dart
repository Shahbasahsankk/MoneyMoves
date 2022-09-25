import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../models/sidebar/enum_sidebar.dart';
import '../../view/add_category_screen/add_category_screen.dart';
import '../../view/home_screen/home_screen.dart';
import '../../view/settings_screen/settings_screen.dart';
import '../../view/statistics_screen/statistics_screen.dart';

class NavigationProvider with ChangeNotifier {
  SidebarNavigationItem _navigationItem = SidebarNavigationItem.home;

  SidebarNavigationItem get navigationItem => _navigationItem;

  void setNavigationItem(SidebarNavigationItem navigationItem) {
    _navigationItem = navigationItem;

    notifyListeners();
  }

  void openSideBar(scaffoldKey) {
    scaffoldKey.currentState!.openDrawer();
  }

  void selectedItem(
      BuildContext context, int index, SidebarNavigationItem item) {
    setNavigationItem(item);
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
            builder: ((context) => AddCategoryScreen()),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => StatisticsScreen()),
          ),
        );

        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => SettingsScreen()),
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
