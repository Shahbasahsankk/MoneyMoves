import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/sizedbox_color_etc.dart';
import '../../../controllers/settings/settings_controller.dart';

class DeleteDailogue extends StatelessWidget {
  const DeleteDailogue({
    super.key,
    required this.text1,
    required this.text2,
    required this.ctx,
  });
  final String text1;
  final String text2;
  final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text(text1),
      actions: [
        TextButton(
          onPressed: () async {
            text1 == 'Reset App?'
                ? provider.resetApp(ctx)
                : provider.deleteTransaction(context);
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
  }
}
