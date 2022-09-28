import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/view/settings_screen/widgets/add_reminder.dart';
import 'package:project/view/settings_screen/widgets/app_info.dart';
import 'package:project/view/settings_screen/widgets/delete_dailogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/sizedbox_color_etc.dart';
import '../../db/category_db/category_db.dart';
import '../../db/transaction_db/transaction_db.dart';
import '../../models/category_model/category_model.dart';
import '../../models/transaction_model/transaction_model.dart';
import '../../view/splash_screen/splash_screen.dart';
import '../reminder/reminder.dart';

class SettingsProvider with ChangeNotifier {
  late Time pickedTime;
  TextEditingController timeController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  bool toggle = false;
  bool isSwitched = false;
  TimeOfDay dateTime = TimeOfDay.now();
  final String info =
      'MONEYMOVES is simply a Money Management Application developed by SHAHBAS, one of the intern in Brototype. This application have a simple and stylish UI and a little features such as adding of your income and expense transactions according to the categories, having a clear graphical overview of your income and expenses, you can examine the transactions through filterations like today, year, last 28 days wises, setting reminders according to your time and being notifies on time, search option is also provided.';

  Future<void> addReminder(context, formkey) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AddReminder(formkey: formkey);
        });
  }

  String? timeValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Select Time';
    } else {
      return null;
    }
  }

  String? textValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Add Some Text';
    } else {
      return null;
    }
  }

  timePicker(context) async {
    TimeOfDay? pickTime =
        await showTimePicker(context: context, initialTime: dateTime);
    if (pickTime != null) {
      String time = pickTime.format(context);

      timeController.text = time;
      pickedTime = Time(
        pickTime.hour,
        pickTime.minute,
      );
      dateTime = pickTime;
    }
  }

  notificationCancel(context) async {
    Navigator.pop(context);
    isSwitched = false;
    timeController.clear();
    labelController.clear();
    notifyListeners();
  }

  notificationSetter(currentState, context) async {
    if (currentState.validate()) {
      final sharefprefs = await SharedPreferences.getInstance();
      sharefprefs.setBool('switch', true);
      NotificationApi().showScheduledNotification(
        title: 'Notification',
        body: labelController.text,
        payload: '',
        scheduledDateTime: pickedTime,
      );
      timeController.clear();
      labelController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('Reminder Added'),
      );
      await getSwitchBool();
    }
  }

  void toggelOnOff(value, context, formKey) async {
    if (value == true) {
      addReminder(context, formKey);
    } else {
      NotificationApi.cancelNotification();
      final share = await SharedPreferences.getInstance();
      share.remove('switch');
      getSwitchBool();
    }
    notifyListeners();
  }

  launchEmail() async {
    String urls = 'mailto:shabum18m@gmail.com';
    final parseurl = Uri.parse(urls);
    try {
      launchUrl(parseurl);
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  launchGithub() async {
    String urls = 'https://github.com/Shahbasahsankk';
    final parseurl = Uri.parse(urls);
    try {
      launchUrl(parseurl);
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  Future getSwitchBool() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    final a = sharedprefs.getBool('switch');
    if (a != null) {
      isSwitched = a;
    } else {
      isSwitched = false;
    }
    notifyListeners();
  }

  deleteTransaction(context) async {
    final transactionDB = await Hive.openBox<TransactionModel>(
        TransactionDbFunction.transactionDbName);
    transactionDB.clear();

    Navigator.pop(context);
  }

  resetApp(BuildContext context) async {
    final categoryDB =
        await Hive.openBox<CategoryModel>(CategoryDbFunction.categoryDbName);
    categoryDB.clear();
    final transactionDB = await Hive.openBox<TransactionModel>(
        TransactionDbFunction.transactionDbName);
    transactionDB.clear();
    NotificationApi.cancelNotification();
    final clear = await SharedPreferences.getInstance();
    clear.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.topToBottom,
          duration: const Duration(seconds: 1),
        ),
        (route) => false);
  }

  settingsScreenDelete(String text1, String text2, context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return DeleteDailogue(text1: text1, text2: text2, ctx: ctx);
      },
    );
  }

  appInfo(context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AppInfo();
      },
    );
  }
}
