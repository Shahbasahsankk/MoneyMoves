import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../controllers/settings/settings_controller.dart';

class AddReminder extends StatelessWidget {
  const AddReminder({super.key, required this.formkey});
  final dynamic formkey;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    return Form(
      key: formkey,
      child: SimpleDialog(
        contentPadding: EdgeInsets.only(
          left: 10.sp,
          right: 10.sp,
          top: 10.sp,
          bottom: 10.sp,
        ),
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => provider.timeValidation(value),
            controller: provider.timeController,
            decoration: const InputDecoration(
              hintText: 'Select Time',
              suffixIcon: Icon(
                Icons.alarm,
                color: Colors.black,
              ),
            ),
            readOnly: true,
            onTap: () => provider.timePicker(context),
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => provider.textValidation(value),
            controller: provider.labelController,
            decoration: const InputDecoration(hintText: 'Add Text'),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => provider.notificationCancel(context),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => provider.notificationSetter(
                      formkey.currentState!, context),
                  child: const Text('Save Reminder'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
