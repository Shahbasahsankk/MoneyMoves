import 'package:flutter/material.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:provider/provider.dart';

class ShowDeleteDialogue extends StatelessWidget {
  const ShowDeleteDialogue({super.key,required this.keyy});
 final dynamic keyy;
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<HomeProvider>(context,listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      content: const Text('Delete Transaction?'),
      actions: [
        TextButton(
          onPressed: () =>provider.deleted(keyy, context),
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
