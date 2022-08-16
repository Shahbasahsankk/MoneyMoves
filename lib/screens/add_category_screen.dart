import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/db/category_db/category_db.dart';
import 'package:project/models/category_model/category_model.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';

import '../Widget_Screens/home_screen_widgets.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController categoryController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    CategoryDbFunction().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 2,
      vsync: this,
    );
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
          width: double.infinity.w,
          color: const Color(0xff232526),
          child: Column(
            children: [
              Padding(
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
              ),
              sizedboxH20,
              Expanded(
                flex: 2,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: CategoryDbFunction.incomeModelNotifier,
                      builder: (BuildContext context,
                          List<CategoryModel> categoryList, Widget? child) {
                        if (categoryList.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 105.h,
                              ),
                              const Image(
                                image: AssetImage(
                                    'lib/assets/no data images/no_categories.png'),
                              ),
                              TextsStyles(
                                name: 'SORRY. NO RESULTS.',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: categoryList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 3),
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () =>
                                      deleteCategory(categoryList[index].id),
                                  child: Container(
                                    height: 15.h,
                                    width: 15.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.r),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w,
                                            right: 8.w,
                                            top: 8.h,
                                            bottom: 8.h),
                                        child: FittedBox(
                                          child: Text(
                                            categoryList[index].name,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: CategoryDbFunction.expenseModelNotifier,
                      builder: (BuildContext context,
                          List<CategoryModel> categoryList, Widget? child) {
                        if (categoryList.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 105.h,
                              ),
                              const Image(
                                image: AssetImage(
                                    'lib/assets/no data images/no_categories.png'),
                              ),
                              TextsStyles(
                                name: 'SORRY. NO RESULTS.',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: categoryList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 3),
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () =>
                                      deleteCategory(categoryList[index].id),
                                  child: Container(
                                    height: 15.h,
                                    width: 15.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.r),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w,
                                            right: 8.w,
                                            top: 8.h,
                                            bottom: 8.h),
                                        child: FittedBox(
                                          child: Text(
                                            categoryList[index].name,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addCategories(tabController);
          },
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

  Future addCategories(TabController tabController) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('New Category'),
          content: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formkey,
            child: TextFormField(
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (tabController.index == 0) {
                  final income = CategoryDbFunction.incomeModelNotifier.value
                      .map((e) => e.name.trim().toLowerCase())
                      .toList();
                  if (income
                      .contains(categoryController.text.trim().toLowerCase())) {
                    return 'Category Already Exists';
                  }
                }
                if (tabController.index == 1) {
                  final expense = CategoryDbFunction.expenseModelNotifier.value
                      .map((e) => e.name.trim().toLowerCase())
                      .toList();
                  if (expense
                      .contains(categoryController.text.trim().toLowerCase())) {
                    return 'Category Already Exists';
                  }
                }
                if (value == '' || value == null) {
                  return 'Not Filled';
                } else {
                  return null;
                }
              },
              controller: categoryController,
              decoration: const InputDecoration(hintText: 'Enter new Category'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                categoryController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  final category = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    type: tabController.index == 0
                        ? CategoryType.income
                        : CategoryType.expense,
                    name: categoryController.text,
                  );
                  await CategoryDbFunction.instance.addCategory(category);

                  if (!mounted) {
                    return;
                  }
                  categoryController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar('Category Added'),
                  );
                }
              },
              child: const Text('Add'),
            )
          ],
        ),
      );

  deleteCategory(String key) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        builder: (ctx) {
          return SizedBox(
            height: 50.h,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  delete(key);
                },
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      );

  delete(String key) => showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Text('Delete Category?'),
          actions: [
            TextButton(
              onPressed: () async {
                await CategoryDbFunction.instance.deleteCategory(key);
                if (!mounted) {}
                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar('Deleted'),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            )
          ],
        );
      });
}
