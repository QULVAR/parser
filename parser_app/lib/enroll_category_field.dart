import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'package:pki_frontend_app/switch.dart';
import 'cart.dart';

class EnrollCategoryField extends StatefulWidget {
  final dynamic item;
  final String category;

  const EnrollCategoryField({
    super.key,
    required this.item,
    required this.category,
  });

  @override
  State<EnrollCategoryField> createState() => _EnrollCategoryFieldState();
}

class _EnrollCategoryFieldState extends State<EnrollCategoryField> {
  double _textWidthText = 0, _textWidthNumber = 0;
  final _switcherKey = GlobalKey<SwitcherState>();

  @override
  void initState() {
    super.initState();
    _recalcMetrics();
  }

  void _recalcMetrics() {
    final style1 = TextStyle(fontSize: 12.sp, color: Colors.grey);
    final tp1 = TextPainter(
      text: TextSpan(text: 'Суточный тариф (Цена за 24 часа)', style: style1),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    _textWidthText = tp1.size.width;

    final style2 = TextStyle(
      fontSize: 13.sp,
      color: const Color.fromARGB(255, 99, 99, 99),
    );
    final tp2 = TextPainter(
      text: TextSpan(text: '${widget.item['price'][0]} ₽', style: style2),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    _textWidthNumber = tp2.size.width;
  }

  void _onPressed(bool inCart) {
    if (inCart) {
      Cart.removeFromCart(widget.category, widget.item['item']);
    } else {
      try {
        Cart.addToCart(widget.category, widget.item['item'], widget.item['price'][4]);
      } catch (_) {
        Cart.addToCart(widget.category, widget.item['item'], '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['item'],
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
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
                      SizedBox(width: 5.w),
                      Text(
                        '${widget.item['price'][0]} ₽',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color.fromARGB(255, 99, 99, 99),
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
                      SizedBox(width: 5.w),
                      Text(
                        '${widget.item['price'][1]} ₽',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color.fromARGB(255, 99, 99, 99),
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
                      SizedBox(width: 5.w),
                      Text(
                        '${widget.item['price'][2]} ₽',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color.fromARGB(255, 99, 99, 99),
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
                      SizedBox(width: 5.w),
                      Text(
                        '${widget.item['price'][3]} ₽',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color.fromARGB(255, 99, 99, 99),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.item['price'].length == 5
                ? Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Text(
                    '${widget.item['price'][4]}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color.fromARGB(255, 99, 99, 99),
                    ),
                  )
                )
                : SizedBox()
              ],
            ),
          ),
          Switcher(
            key: _switcherKey,
            height: 25.h,
            width: 50.w,
            onPress: _onPressed
          )
        ],
      ),
    );
  }
}
