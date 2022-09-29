import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/controllers/transaction/transaction_controller.dart';

import '../../../constants/sizedbox_padding_etc.dart';

class SearchAndFilterChange extends StatelessWidget {
  const SearchAndFilterChange({
    super.key,
    required this.values,
    required this.pading,
  });
  final TransactionProvider values;
  final EdgeInsetsGeometry pading;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: values.search == false
          ? Padding(
              key: const Key('1'),
              padding: pading,
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
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                hint: const Text("Category"),
                                value: values.currentCategory,
                                isDense: true,
                                onChanged: (newCategory) =>
                                    values.categoryChange(newCategory),
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
                                onChanged: (selectedTransaction) => values
                                    .transactionChange(selectedTransaction),
                                items: <String>[
                                  'All',
                                  'Income',
                                  'Expense',
                                ].map(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  },
                                ).toList(),
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
                autofocus: values.founData.length > 3 ? true : false,
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
            ),
    );
  }
}
