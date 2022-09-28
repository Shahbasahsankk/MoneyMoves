import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/settings/settings_controller.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/view/settings_screen/widgets/settings_item.dart';
import 'package:project/controllers/reminder/reminder.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigation/sidebar_controller.dart';
import '../sidabar_menu/sidebar_drawer.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getSwitchBool();
      NotificationApi.init(initScheduled: true);
    });
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        drawer: const SidebarMenu(),
        appBar: AppBar(
          title: TextsStyles(
            name: 'Settings',
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => navigationProvider.openSideBar(_scaffoldKey),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: double.infinity.h,
          width: double.infinity.w,
          color: const Color(0xff232526),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            children: [
              SettingItem(
                toggle: true,
                text: 'Reminder',
                iconData: Icons.alarm,
                context: context,
                formKey: formkey,
              ),
              SettingItem(
                context: context,
                text: 'Reset App',
                iconData: Icons.restart_alt_rounded,
                onClicked: () => provider.settingsScreenDelete(
                  'Reset App?',
                  'Data Reseted',
                  context,
                ),
                formKey: formkey,
              ),
              SettingItem(
                context: context,
                text: 'Clear Transaction History',
                iconData: Icons.repeat_sharp,
                onClicked: () => provider.settingsScreenDelete(
                  'All Transaction Will Be Deleted,Continue?',
                  'All Transaction Deleted',
                  context,
                ),
                formKey: formkey,
              ),
              SettingItem(
                context: context,
                text: 'Contact Us',
                iconData: Icons.contact_page,
                onClicked: () => provider.launchEmail(),
                formKey: formkey,
              ),
              SettingItem(
                context: context,
                text: 'App Info',
                iconData: Icons.info,
                onClicked: () => provider.appInfo(context),
                formKey: formkey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
