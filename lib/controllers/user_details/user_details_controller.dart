import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/home_screen/home_screen.dart';

class UserDetailsProvider with ChangeNotifier {
  final formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final RegExp reg =
      RegExp(r'''[ +×÷=/_€£¥₩;'`~\°•○●□■♤♡◇♧☆▪︎¤《》¡¿!@#$%^&*(),.?":{}|<>]''');

  String? validation(value) {
    if (value == null || value.isEmpty) {
      return "Fill Your Name";
    }
    if (value.startsWith(RegExp(r'[0-9]'))) {
      return "Name Must Starts With Letters";
    }
    if (value.startsWith(reg)) {
      return "Name Can't Starts With Special Characters";
    } else {
      return null;
    }
  }

  void goToHome(context) async {
    if (formkey.currentState!.validate()) {
      final sharefprefs = await SharedPreferences.getInstance();
      sharefprefs.setString('username', nameController.text);
      Navigator.of(context).pushAndRemoveUntil(
          (MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          )),
          (route) => false);
    }
  }
}
