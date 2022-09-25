import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/home_screen/home_screen.dart';
import '../../view/welcome_screen/welcome_screen.dart';

class SplashProvider with ChangeNotifier {
  Future<void> splash(context) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final name = shared.getString('username');
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (name == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const WelcomeScreen()),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        ),
      );
    } 
  }
}
