import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'package:lottie/lottie.dart';

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

class _EnrollCategoryFieldState extends State<EnrollCategoryField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool inCart = false;
  double _textWidthText = 0, _textWidthNumber = 0;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
    _recalcMetrics();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
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

  void _onPressed() {
    if (_c.isAnimating) return;
    if (inCart) {
      _c.reverse(from: 1.0);
    } else {
      _c.forward(from: 0.0);
    }
    setState(() => inCart = !inCart);
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
              ],
            ),
          ),
          IconButton(
            onPressed: _onPressed,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Lottie.asset(
              'assets/animations/checkbox.json',
              height: 32.sp,
              controller: _c,
              animate: false,
              repeat: false,
              onLoaded: (comp) {
                _c.duration = comp.duration * 0.25;
                _c.value = inCart ? 1.0 : 0.0;
              },
              options: LottieOptions(enableMergePaths: true),
            ),
          ),
        ],
      ),
    );
  }
}
