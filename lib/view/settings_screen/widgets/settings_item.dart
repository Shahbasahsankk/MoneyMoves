import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/sizedbox_color_etc.dart';
import '../../../controllers/settings/settings_controller.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.context,
    required this.iconData,
    this.onClicked,
    required this.text,
    this.toggle,
    required this.formKey,
  });
  final IconData iconData;
  final VoidCallback? onClicked;
  final String text;
  final bool? toggle;
  final BuildContext context;
  final dynamic formKey;
  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        iconData,
        color: color,
        size: 25.sp,
      ),
      title: TextsStyles(
        name: text,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      trailing: toggle == true
          ? Consumer<SettingsProvider>(
              builder: (context, values, _) {
                return Switch(
                  value: values.isSwitched,
                  onChanged: (value) =>
                      values.toggelOnOff(value, context, formKey),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.white38,
                  activeTrackColor: Colors.white60,
                  activeColor: Colors.black,
                );
              },
            )
          : const SizedBox(),
      onTap: onClicked,
    );
  }
}
