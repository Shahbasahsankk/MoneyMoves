import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Utilities/sizedbox_color_etc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final RegExp reg=RegExp(r'''[ +×÷=/_€£¥₩;'`~\°•○●□■♤♡◇♧☆▪︎¤《》¡¿!@#$%^&*(),.?":{}|<>]''');
  @override
  Widget build(BuildContext context) {
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
                padding:  EdgeInsets.only(left:18.w,right: 18.w,top: 18.h,bottom: 18.h),
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
                      key: _formkey,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Fill Your Name";
                          } if (value.startsWith(RegExp(r'[0-9]'))) {
                            return "Name Must Starts With Letters";
                          }if(value.startsWith(reg)){
                           return  "Name Can't Starts With Special Characters";
                          } else{
                            return null;
                          }
                        },
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
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    final sharefprefs = await SharedPreferences.getInstance();
                    sharefprefs.setString('username', nameController.text);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        (MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        )),
                        (route) => false);
                  }
                },
                child:  TextsStyles(
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
