import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'enroll_category_field.dart';

class EnrollCategory extends StatefulWidget {
  final Map<String, dynamic> category;
  const EnrollCategory({super.key, required this.category});

  @override
  State<EnrollCategory> createState() => _EnrollCategoryState();
}

class _EnrollCategoryState extends State<EnrollCategory>
    with AutomaticKeepAliveClientMixin {
  bool rolled = false;
  double _fontSize = 18.sp;

  void _recalcMetrics() {
    double localFontSize = 19;
    double localTextWidth;
    do {
      localFontSize -= 1;
      final style = TextStyle(
        fontSize: localFontSize.sp,
        color: Color.fromARGB(255, 22, 101, 165),
      );

      final text = widget.category['category'];
      final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(minWidth: 0, maxWidth: double.infinity);
      localTextWidth = tp.size.width;
    } while (localTextWidth > 349.w - 24.sp);
    setState(() {
      _fontSize = localFontSize;
    });
  }

  void _toggle() => setState(() => rolled = !rolled);

  @override
  void initState() {
    super.initState();
    _recalcMetrics();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: 370.w,
      margin: EdgeInsets.only(top: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(width: 2, color: Color(0xFF95979A)),
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: _toggle,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.category['category'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _fontSize.sp,
                      color: Color.fromARGB(255, 22, 101, 165),
                    ),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  turns: rolled ? 0.5 : 0.0,
                  child: SvgPicture.asset(
                    "assets/icons/arrow_down.svg",
                    width: 24.sp,
                    height: 24.sp,
                  ),
                ),
              ],
            ),
          ),
          ClipRect(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              tween: Tween(begin: rolled ? 1 : 0, end: rolled ? 1 : 0),
              builder: (context, value, child) => Align(
                alignment: Alignment.topCenter,
                heightFactor: value,
                child: child,
              ),
              child: Container(
                margin: EdgeInsets.only(left: 10.w, bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (widget.category['items'] as List)
                      .map<Widget>(
                        (item) => EnrollCategoryField(
                          item: item,
                          category: widget.category['category'],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
