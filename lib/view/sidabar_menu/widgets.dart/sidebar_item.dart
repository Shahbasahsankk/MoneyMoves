import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/sizedbox_color_etc.dart';
import '../../../controllers/navigation/sidebar_controller.dart';
import '../../../models/sidebar/enum_sidebar.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem(
      {super.key,
      required this.text,
      required this.iconData,
      required this.item,
      this.onClicked});

  final String text;
  final IconData iconData;
  final SidebarNavigationItem item;
  final VoidCallback? onClicked;
  @override
  Widget build(BuildContext context) {
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
}
