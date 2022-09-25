import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/user_details_screen/user_details.dart';


class WelcomeProvider extends ChangeNotifier {
  void gotoUser(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const UserDetailsScreen()),
      ),
    );
  }
}
