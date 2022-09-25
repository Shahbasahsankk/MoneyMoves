import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project/controllers/home/home_controllers.dart';
import 'package:project/controllers/transaction/transaction_controller.dart';
import 'package:project/db/transaction_db/transaction_db.dart';
import 'package:project/constants/sizedbox_color_etc.dart';
import 'package:provider/provider.dart';
import '../../models/transaction_model/transaction_model.dart';
import '../add_transaction_screen/add_screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final provider = Provider.of<TransactionProvider>(context, listen: false);
     provider.founData = provider.allData;
        homeProvider.refresh(context);
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp)async {
   
       provider.allData = homeProvider.allTransactionList;
      provider.currentCategory = 'All';
      provider.currentTransaction = 'All';
      
    });
    final padding = EdgeInsets.only(left: 12.w, right: 12.w);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Transactions'),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity.h,
          width: double.infinity.w,
          color: const Color(0xff232526),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Consumer<TransactionProvider>(
                  builder: (context,values,_) {
                    return values.search == false
                        ? Padding(
                            key: const Key('1'),
                            padding: padding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          contentPadding: contentPadding,
                                          fillColor: Colors.white70,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            DropdownButton<String>(
                                              hint: const Text("Category"),
                                              value: values.currentCategory,
                                              isDense: true,
                                              onChanged: (newCategory) => values
                                                  .categoryChange(newCategory),
                                              items: <String>[
                                                'All',
                                                'Today',
                                                'Last 28 Days',
                                                'This Year',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                            DropdownButton<String>(
                                              hint: const Text("Transaction "),
                                              value: values.currentTransaction,
                                              isDense: true,
                                              onChanged: (selectedTransaction) =>
                                                  values.transactionChange(
                                                      selectedTransaction),
                                              items: <String>[
                                                'All',
                                                'Income',
                                                'Expense',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                  ),
                                                );
                                              },).toList(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => values.searchChange(true),
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 40.sp,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Padding(
                            key: const Key('2'),
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.words,
                              autofocus:
                                  values.founData.length > 3 ? true : false,
                              onChanged: (value) => values.searchFilter(value),
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                hintText: 'Search',
                                suffixIcon: IconButton(
                                  onPressed: () => values.searchChange(false),
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          );
                  }
                ),
              ),
              sizedboxH20,
              Expanded(
                child: Consumer<TransactionProvider>(
                  builder: (context,values,_) {
                    return values.founData.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              final list = values.founData[index];
                              return Padding(
                                padding: EdgeInsets.only(left: 13.w, right: 13.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 8.w),
                                    onTap: () => homeProvider.options(index,
                                        values.founData[index].id, list, context),
                                    leading: CircleAvatar(
                                      backgroundImage: values.founData[index]
                                                  .transactionType ==
                                              'Income'
                                          ? const AssetImage(
                                              'lib/assets/expense & income gifs/income.png')
                                          : const AssetImage(
                                              'lib/assets/expense & income gifs/expense.jpg'),
                                      backgroundColor: Colors.white,
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextsStyles(
                                          name:
                                              values.founData[index].categoryType,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        TextsStyles(
                                          name: DateFormat('yMMMMd').format(
                                            values.founData[index].date,
                                          ),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    trailing: TextsStyles(
                                      name:
                                          '₹${values.founData[index].amount.toString()}',
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: values.founData.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 105.h,
                              ),
                              const Image(
                                image: AssetImage(
                                    'lib/assets/no data images/file_not_found.png'),
                              ),
                              TextsStyles(
                                name: 'SORRY. NO RESULTS.',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ],
                          );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  options(index, TransactionModel data, context) => showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      builder: (BuildContext ctx) {
        return SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => AddScreen(
                            model: data,
                            type: ActionType.editScreen,
                          )),
                    ),
                  );
                },
                child: const Icon(Icons.edit),
              ),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    delete(index, context);
                  },
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ))
            ],
          ),
        );
      });

  delete(key, context) => showDialog(
        context: context,
        builder: (ctx) {
          final provider =
              Provider.of<TransactionProvider>(context, listen: false);
          return AlertDialog(
            backgroundColor: Colors.white,
            content: const Text('Delete Transaction?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await TransactionDbFunction.instance
                      .deleteTransaction(key, context);
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => provider.filter);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar('Deleted'),
                  );
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
