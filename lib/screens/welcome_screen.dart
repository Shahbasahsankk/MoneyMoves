import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Models/model_classes.dart';
import 'package:project/Screens/user_details.dart';
import 'package:project/Utilities/sizedbox_color_etc.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  final List<WelcomeModel> welcomemodel = [
    WelcomeModel(
      image: 'lib/assets/welcome images/transactions.gif',
      text: 'Track Your Daily, Monthly,\nYearly Income And Expense',
    ),
    WelcomeModel(
      image: 'lib/assets/welcome images/graph.gif',
      text: 'Have A Graphical Overview Of\nYour Income and Expense',
    ),
    WelcomeModel(
      image: 'lib/assets/welcome images/reminder.gif',
      text: 'Set Reminder To Get Notified\nAbout Your Transactions',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDDFFDD),
        body: PageView.builder(
          itemCount: welcomemodel.length,
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
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: ((context) => UserDetailsScreen()),
                                ),
                              );
                            },
                            child:  Text(
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
                        welcomemodel[index].image,
                      ),
                    ),
                  ),
                ),
                Text(
                  welcomemodel[index].text,
                  style:  TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                index == 2
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((context) => UserDetailsScreen()),
                              ),
                            );
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ))
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
