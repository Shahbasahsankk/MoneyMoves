import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/user_details/user_details_controller.dart';
import 'package:provider/provider.dart';

import '../../constants/sizedbox_color_etc.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDetailsProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity.w,
                height: 300.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'lib/assets/welcome images/username.jpg',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 18.w, right: 18.w, top: 18.h, bottom: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextsStyles(
                      name: 'Set Your Profile Name',
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    sizedboxH20,
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: provider.formkey,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: provider.nameController,
                        validator: (value) => provider.validation(value),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          hintText: 'Enter Your Name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              TextButton(
                onPressed: ()=>provider.goToHome(context),
                child: TextsStyles(
                  name: 'Next',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
