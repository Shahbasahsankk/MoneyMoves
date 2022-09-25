import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/view/sidabar_menu/widgets.dart/sidebar_item.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigation/sidebar_controller.dart';
import '../../models/sidebar/enum_sidebar.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: padding,
        children: [
          SizedBox(
            height: 150.h,
          ),
          BuildMenuItem(
            text: 'Home',
            iconData: Icons.home,
            onClicked: () =>
                provider.selectedItem(context, 0, SidebarNavigationItem.home),
            item: SidebarNavigationItem.home,
          ),
          BuildMenuItem(
            text: 'Categories',
            iconData: Icons.category,
            onClicked: () => provider.selectedItem(
                context, 1, SidebarNavigationItem.categories),
            item: SidebarNavigationItem.categories,
          ),
          BuildMenuItem(
            text: 'Statistics',
            iconData: Icons.pie_chart,
            onClicked: () => provider.selectedItem(
                context, 2, SidebarNavigationItem.statistics),
            item: SidebarNavigationItem.statistics,
          ),
          BuildMenuItem(
            text: 'Settings',
            iconData: Icons.settings,
            onClicked: () => provider.selectedItem(
                context, 3, SidebarNavigationItem.settings),
            item: SidebarNavigationItem.settings,
          ),
          BuildMenuItem(
            text: 'Share App',
            iconData: Icons.share,
            item: SidebarNavigationItem.share,
            onClicked: () =>
                provider.selectedItem(context, 4, SidebarNavigationItem.share),
          )
        ],
      ),
    );
  }
}
