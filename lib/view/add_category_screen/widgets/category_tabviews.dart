import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:provider/provider.dart';

import '../../../constants/text_widget.dart';

class CategoryTabViews extends StatelessWidget {
  const CategoryTabViews({super.key, required this.list});
  final dynamic list;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddCategoryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.modelListChecking(list);
    });
    return provider.modelList.isEmpty
        ? Column(
            children: [
              SizedBox(
                height: 105.h,
              ),
              const Image(
                image:
                    AssetImage('lib/assets/no data images/no_categories.png'),
              ),
              TextsStyles(
                name: 'SORRY. NO RESULTS.',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          )
        : Padding(
            padding:
                EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 3),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => provider.bottomDeleteShow(
                    provider.modelList[index].id,
                    context,
                  ),
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
                          bottom: 8.h,
                        ),
                        child: FittedBox(
                          child: Text(list[index].name),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
