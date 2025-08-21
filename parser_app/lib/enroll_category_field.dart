import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pki_frontend_app/resizer.dart';

class EnrollCategoryField extends StatefulWidget {
  final item;

  const EnrollCategoryField({super.key, required this.item});

  @override
  State<EnrollCategoryField> createState() => EnrollCategoryFieldState();
}

class EnrollCategoryFieldState extends State<EnrollCategoryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: BoxBorder.all(width: 2, color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item['item'],
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Суточный тариф (Цена за 24 часа)',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey
                ),
              ),
              Text(
                'Недельный',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey
                ),
              ),
              Text(
                'С Чт 17.00 до Пн 12.00',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey
                ),
              ),
              Text(
                'С Пт 17.00 до Пн 12.00',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey
                ),
              )
            ]),
            SizedBox(width: 5.w,),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.item['price'][0]} ₽',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color.fromARGB(255, 99, 99, 99)
                ),
              ),
              Text(
                '${widget.item['price'][1]} ₽',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color.fromARGB(255, 99, 99, 99)
                ),
              ),
              Text(
                '${widget.item['price'][2]} ₽',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color.fromARGB(255, 99, 99, 99)
                ),
              ),
              Text(
                '${widget.item['price'][3]} ₽',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color.fromARGB(255, 99, 99, 99)
                ),
              )
            ])
            ],
          )
        ],
      ),
    );
  }
}