import 'package:flutter/material.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/models/transaction_model/transaction_model.dart';
import 'package:provider/provider.dart';


class BottomShow extends StatelessWidget {
  const BottomShow(
      {super.key, required this.data, required this.index, required this.keyy});
  final TransactionModel data;
  final int index;
  final dynamic keyy;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: ()=>provider.toEditScreen(context, data),
            child: const Icon(Icons.edit),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              provider.delete(keyy, context);
            },
            child: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
