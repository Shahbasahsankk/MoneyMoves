import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/Screens/splash_screen.dart';
import 'package:project/db/category_db/category_db.dart';
import 'package:project/db/transaction_db/transaction_db.dart';
import 'package:project/models/category_model/category_model.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:project/utilities/sizedbox_color_etc.dart';
import 'package:project/widget_screens/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widget_Screens/home_screen_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

late Time pickedTime;
TextEditingController timeController = TextEditingController();
TextEditingController labelController = TextEditingController();
final formkey = GlobalKey<FormState>();

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool toggle = false;
  bool isSwitched = false;
  TimeOfDay dateTime = TimeOfDay.now();
  final String info =
      'MONEYMOVES is simply a Money Management Application developed by SHAHBAS, one of the intern in Brototype. This application have a simple and stylish UI and a little features such as adding of your income and expense transactions according to the categories, having a clear graphical overview of your income and expenses, you can examine the transactions through filterations like today, year, last 28 days wises, setting reminders according to your time and being notifies on time, search option is also provided.';

  @override
  void initState() {
    getBool();
    NotificationApi.init(initScheduled: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        drawer: const SidebarMenu(),
        appBar: AppBar(
          title: TextsStyles(
            name: 'Settings',
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: double.infinity.h,
          width: double.infinity.w,
          color: const Color(0xff232526),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            children: [
              settingsItem(
                context,
                toggle: true,
                text: 'Reminder',
                iconData: Icons.alarm,
              ),
              settingsItem(context,
                  text: 'Reset App',
                  iconData: Icons.restart_alt_rounded, onClicked: () {
                delete('Reset App?', 'Data Reseted');
              }),
              settingsItem(context,
                  text: 'Clear Transaction History',
                  iconData: Icons.repeat_sharp, onClicked: () {
                delete('All Transaction Will Be Deleted,Continue?',
                    'All Transaction Deleted');
              }),
              settingsItem(
                context,
                text: 'Contact Us',
                iconData: Icons.contact_page,
                onClicked: () => launchEmail(),
              ),
              settingsItem(
                context,
                text: 'App Info',
                iconData: Icons.info,
                onClicked: () => appInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsItem(BuildContext context,
      {required String text,
      required IconData iconData,
      VoidCallback? onClicked,
      bool? toggle}) {
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
          ? Switch(
              value: isSwitched,
              onChanged: (value) async {
                setState(() {
                  isSwitched = value;
                });
                if (isSwitched == true) {
                  addReminder();
                } else {
                  NotificationApi.cancelNotification();
                  final share = await SharedPreferences.getInstance();
                  share.remove('switch');
                  setState(() {});
                }
              },
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.white38,
              activeTrackColor: Colors.white60,
              activeColor: Colors.black,
            )
          : const SizedBox(),
      onTap: onClicked,
    );
  }

  void delete(
    String text1,
    String text2,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(text1),
          actions: [
            TextButton(
              onPressed: () async {
                text1 == 'Reset App?' ? resetApp(ctx) : deleteTransaction();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                text2 == 'All Transaction Deleted'
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(text2),
                      )
                    : null;
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            )
          ],
        );
      },
    );
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

  resetApp(BuildContext ctx) async {
    final categoryDB =
        await Hive.openBox<CategoryModel>(CategoryDbFunction.categoryDbName);
    categoryDB.clear();
    final transactionDB = await Hive.openBox<TransactionModel>(
        TransactionDbFunction.transactionDbName);
    transactionDB.clear();
    NotificationApi.cancelNotification();
    final clear = await SharedPreferences.getInstance();
    clear.clear();
    if (!mounted) {
      return;
    }
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.topToBottom,
          duration: const Duration(seconds: 1),
        ),
        (route) => false);
  }

  deleteTransaction() async {
    final transactionDB = await Hive.openBox<TransactionModel>(
        TransactionDbFunction.transactionDbName);
    transactionDB.clear();
    if (!mounted) {}
    Navigator.pop(context);
  }

  appInfo() => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
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
                name: info,
                fontSize: 14.sp,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: IconButton(
                  onPressed: () {
                    launchGithub();
                  },
                  icon:
                   const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Future<void> addReminder() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select Time';
                  }
                  return null;
                },
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Select Time',
                  suffixIcon: Icon(
                    Icons.alarm,
                    color: Colors.black,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickTime = await showTimePicker(
                      context: context, initialTime: dateTime);
                  if (pickTime != null) {
                    if (!mounted) {}
                    String time = pickTime.format(context);
                    setState(() {
                      timeController.text = time;
                      pickedTime = Time(
                        pickTime.hour,
                        pickTime.minute,
                      );
                      dateTime = pickTime;
                    });
                  }
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Add Some Text';
                  }
                  return null;
                },
                controller: labelController,
                decoration: const InputDecoration(hintText: 'Add Text'),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (!mounted) {}
                        Navigator.pop(context);
                        setState(() {
                          isSwitched = false;
                          timeController.clear();
                          labelController.clear();
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            final sharefprefs =
                                await SharedPreferences.getInstance();
                            sharefprefs.setBool('switch', true);
                            setState(() {
                              NotificationApi().showScheduledNotification(
                                title: 'Notification',
                                body: labelController.text,
                                payload: '',
                                scheduledDateTime: pickedTime,
                              );

                              timeController.clear();
                              labelController.clear();
                            });
                            if (!mounted) {}
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar('Reminder Added'),
                            );
                          }
                        },
                        child: const Text('Save Reminder'))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future getBool() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    final a = sharedprefs.getBool('switch');
    if (a != null) {
      setState(() {
        isSwitched = a;
      });
    } else {
      isSwitched = false;
    }
  }
}
