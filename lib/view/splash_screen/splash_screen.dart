import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/constants/text_widget.dart';
import 'package:project/controllers/splash/splash_controllers.dart';
import 'package:project/helpers/splash_helper.dart';
import 'package:provider/provider.dart';

import '../../constants/sizedbox_padding_etc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SplashProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SplashTexts().splashmodel.shuffle();
      provider.splash(context);
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff232526),
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
              name: SplashTexts().splashmodel[3].text,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            sizedboxH20,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextsStyles(
                  name: SplashTexts().splashmodel[5].author,
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
}
