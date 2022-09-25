import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/add_category/add_category_controller.dart';
import 'package:project/controllers/add_transaction/add_transaction_controller.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/controllers/settings/settings_controller.dart';

import 'package:project/controllers/splash/splash_controllers.dart';
import 'package:project/controllers/statistics/statistics_controller.dart';
import 'package:project/controllers/transaction/transaction_controller.dart';
import 'package:project/controllers/welcome/welcome_controllers.dart';
import 'package:project/view/splash_screen/splash_screen.dart';
import 'package:project/widget_screens/reminder.dart';
import 'package:provider/provider.dart';

import 'controllers/navigation/sidebar_controller.dart';
import 'controllers/user_details/user_details_controller.dart';
import 'db/initialise.dart';

void main() async {
  CatAndTranInitialize().initializeTransAndCat();
  await NotificationApi.init();
  NotificationApi.notificationDetails();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => WelcomeProvider()),
        ChangeNotifierProvider(create: (context) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => StatisticsProvider()),
        ChangeNotifierProvider(create: (context) => AddCategoryProvider()),
        ChangeNotifierProvider(create: (context) => AddTransactionProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Money App',
            theme: ThemeData(
              primarySwatch: Colors.brown,
              fontFamily: 'NunitoSans',
            ),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
