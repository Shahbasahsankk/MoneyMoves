import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/view/home_screen/widgets/home_screen_main_box.dart';
import 'package:project/view/home_screen/widgets/home_transaction_lists.dart';
import 'package:provider/provider.dart';

import '../../constants/sizedbox_padding_etc.dart';
import '../../constants/text_widget.dart';
import '../../controllers/navigation/sidebar_controller.dart';
import '../../models/sidebar/enum_sidebar.dart';
import '../sidabar_menu/sidebar_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      navigationProvider.setNavigationItem(SidebarNavigationItem.home);
      provider.getName();
      await provider.refresh(context);
    });
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const SidebarMenu(),
        body: Container(
          color: const Color(0xff232526),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 12.h,
                  bottom: 12.h,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          navigationProvider.openSideBar(scaffoldKey),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    sizedboxW15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextsStyles(
                            fontSize: 18.sp,
                            name: 'Welcome',
                            color: Colors.blue,
                          ),
                          Consumer<HomeProvider>(builder: (context, value, _) {
                            return TextsStyles(
                              fontSize: 25.sp,
                              name: value.name ?? '',
                              color: Colors.white,
                            );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const HomeBox(),
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextsStyles(
                      name: 'RECENT  TRANSACTIONS',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    TextButton(
                      onPressed: () => provider.toTransactionScreen(context),
                      child: TextsStyles(
                        name: 'View All',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const HomeTransactionList(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => provider.toAddScreen(context),
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 40.sp,
          ),
        ),
      ),
    );
  }
}
