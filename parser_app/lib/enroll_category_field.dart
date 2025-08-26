import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

class EnrollCategoryField extends StatefulWidget {
  final item;

  const EnrollCategoryField({super.key, required this.item});

  @override
  State<EnrollCategoryField> createState() => EnrollCategoryFieldState();
}

class EnrollCategoryFieldState extends State<EnrollCategoryField> {

  late double _textWidthText;
  late double _textWidthNumber;

  void _recalcMetrics() {
    double localTextWidth;
    double localTextWidth2;
    final style1 = TextStyle(fontSize: 12.sp, color: Colors.grey);

    final text = 'Суточный тариф (Цена за 24 часа)';
    final tp = TextPainter(
      text: TextSpan(text: text, style: style1),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    localTextWidth = tp.size.width;

    final style2 = TextStyle(
        fontSize: 13.sp,
        color: Color.fromARGB(255, 99, 99, 99),
    );
    final text2 = '${widget.item['price'][0]} ₽';
    final tp2 = TextPainter(
      text: TextSpan(text: text2, style: style2),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    localTextWidth2 = tp2.size.width;

    setState(() {
      _textWidthText = localTextWidth;
      _textWidthNumber = localTextWidth2;
    });
  }

  @override
  Widget build(BuildContext context) {
    _recalcMetrics();
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
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: _textWidthText + _textWidthNumber + 5.w + 10.w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Суточный тариф (Цена за 24 часа)',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          '${widget.item['price'][0]} ₽',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: _textWidthText + _textWidthNumber + 5.w + 10.w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                        'Недельный',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                        ),

                      SizedBox(width: 5.w,),
                        Text(
                          '${widget.item['price'][1]} ₽',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: _textWidthText + _textWidthNumber + 5.w + 10.w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'С Чт 17.00 до Пн 12.00',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          '${widget.item['price'][2]} ₽',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: _textWidthText + _textWidthNumber + 5.w + 10.w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'С Пт 17.00 до Пн 12.00',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          '${widget.item['price'][3]} ₽',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}