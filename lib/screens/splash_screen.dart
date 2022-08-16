import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Models/model_classes.dart';
import 'package:project/Screens/home_screen.dart';
import 'package:project/Screens/welcome_screen.dart';
import 'package:project/Utilities/sizedbox_color_etc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/navigation_provier.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<SplashModel> splashmodel = [
    SplashModel(
      text:
          '“Beware Of\n Little Expenses\n A Small Leak\n Will Sink A\n Great Ship”’',
      author: '-Benjamin Franklin',
    ),
    SplashModel(
      text:
          "“Every Time\n You Borrow Money,\n You're Robbing Your\n Future Self”",
      author: '-Nathan W. Morris',
    ),
    SplashModel(
      text: '“Never Spend Your\n Money before\n You Have It”',
      author: '-Thomas Jefferson',
    ),
    SplashModel(
      text:
          "“It's Not Your Salary\n That Makes You\n Rich, It's Your\n Spending Habits”",
      author: '-Charles Jaffe',
    ),
    SplashModel(
      text:
          '“Money Management Is\n The Only Strategy To\n Survive In This Crazy,\n Stupid And Doped\n Financial World Market”',
      author: '-William C. Brown',
    ),
    SplashModel(
      text:
          '“The Art Of Living\n Easily As To Money\n Is To Pitch Your Scale\n Of Living One Degree\n Below Your Means”',
      author: '-Henry Taylor',
    ),
    SplashModel(
      text:
          '“Money Is Only A Tool\n It Will Take You\n Wherever You Wish,\n But It Will Not\n Replace You As\n The Driver”',
      author: '-Ayn Rand',
    ),
    SplashModel(
      text: '“Wealth Is The\n Ability To Fully\n Experience Life”',
      author: '-Henry David Thoreau',
    ),
    SplashModel(
      text:
          '“You Can Be Young\n Without Money,\n But You Can’t Be\n Old Without It”',
      author: '-Tennessee Williams',
    ),
    SplashModel(
      text: '“Don’t Stay In Bed,\n Unless You Can Make\n Money In Bed”',
      author: '-George Burns',
    ),
  ];

  @override
  void initState() {
    splashmodel.shuffle();
     splash();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:const Color(0xff232526),
        body: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 150.h,
                ),
                Image(
                  height: 150.h,
                  width: 150.w,
                  image: const AssetImage('lib/assets/logo/image.png'),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'MONEYMOVES',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.sp,
                      ),
                      colors: [
                        Colors.yellow,
                        Colors.white,
                        Colors.black,
                      ],
                    ),
                  ],
                ),
              ],
            ),
            sizedboxH30,
            TextsStyles(
              fontSize: 30.sp,
              name: splashmodel[3].text,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            sizedboxH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextsStyles(
                  name: splashmodel[5].author,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
                sizedboxW80,
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> splash() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final name = shared.getString('username');
    await Future.delayed(
      const Duration(seconds: 3),
    );
    if (!mounted) {
      return;
    }
    if (name != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => WelcomeScreen()),
        ),
      );
    }

    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(SidebarNavigationItem.home);
  }
}
