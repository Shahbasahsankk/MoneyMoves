import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.value,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String text;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black,
                child: Icon(
                  icon,
                  color: color,
                  size: 30.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  fontSize: 25.sp,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
