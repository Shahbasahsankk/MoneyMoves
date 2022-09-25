import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:project/controllers/welcome/welcome_controllers.dart';
import 'package:project/helpers/welcome_helper.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WelcomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDDFFDD),
        body: PageView.builder(
          itemCount: WelcomeTexts().welcomemodel.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                index == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              provider.gotoUser(context);
                            },
                            child: Text(
                              'SKIP',
                              style: TextStyle(
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                          sizedboxW20,
                        ],
                      )
                    : Container(),
                Container(
                  height: 400.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        WelcomeTexts().welcomemodel[index].image,
                      ),
                    ),
                  ),
                ),
                Text(
                  WelcomeTexts().welcomemodel[index].text,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                index == 2
                    ? ElevatedButton(
                        onPressed: () {
                          provider.gotoUser(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            'SWIPE RIGHT',
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20.sp,
                            ),
                          ),
                          sizedboxH30,
                          const Icon(
                            Icons.swipe_right_rounded,
                          )
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
