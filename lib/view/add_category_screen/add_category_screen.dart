import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/navigation/sidebar_controller.dart';
import 'package:project/view/add_category_screen/widgets/category_tabs.dart';
import 'package:project/view/add_category_screen/widgets/category_tabviews.dart';
import 'package:provider/provider.dart';

import '../../constants/sizedbox_padding_etc.dart';
import '../sidabar_menu/sidebar_drawer.dart';

// ignore: must_be_immutable
class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddCategoryProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.refresh(context);
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        drawer: const SidebarMenu(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Categories'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => navigationProvider.openSideBar(_scaffoldKey),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            tabController = TabController(
              length: 2,
              vsync: Scaffold.of(context),
            );
            return Container(
              width: double.infinity.w,
              color: const Color(0xff232526),
              child: Column(
                children: [
                  CategoryTabs(tabController: tabController),
                  sizedboxH20,
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Consumer<AddCategoryProvider>(
                          builder: (BuildContext context, values, _) {
                            return CategoryTabViews(
                                list: values.incomeModelList);
                          },
                        ),
                        Consumer<AddCategoryProvider>(
                          builder: (BuildContext context, values, _) {
                            return CategoryTabViews(
                                list: values.expenseModelList);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              provider.categoryShow(context, formkey, tabController),
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
