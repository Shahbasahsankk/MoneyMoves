import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/controllers/settings/settings_controller.dart';
import 'package:provider/provider.dart';

import '../../../constants/sizedbox_padding_etc.dart';
import '../../../constants/text_widget.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    return SimpleDialog(
      title: Column(
        children: [
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'MONEYMOVES',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
                colors: [
                  Colors.black,
                  Colors.red,
                ],
              ),
            ],
          ),
          TextsStyles(
            name: 'v 1.0.2',
            fontSize: 15.sp,
          ),
          sizedboxH20,
          TextsStyles(
            name: provider.info,
            fontSize: 14.sp,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: IconButton(
              onPressed: () => provider.launchGithub(),
              icon: const FaIcon(
                FontAwesomeIcons.github,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
