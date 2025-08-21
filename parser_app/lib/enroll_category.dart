import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'enroll_category_field.dart';

class EnrollCategory extends StatefulWidget {
  final category;

  const EnrollCategory({super.key, required this.category});

  @override
  State<EnrollCategory> createState() => EnrollCategoryState();
}

class EnrollCategoryState extends State<EnrollCategory> {
  bool rolled = false;

  void changeSize() {
    setState(() {
      rolled = !rolled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(width: 2, color: Colors.black),
      ),
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          TextButton(
            onPressed: changeSize,
            style: ButtonStyle(splashFactory: null, shadowColor: null),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.category['category']),
                SvgPicture.asset(
                  rolled
                      ? "assets/icons/arrow_up.svg"
                      : "assets/icons/arrow_down.svg",
                  key: ValueKey(rolled),
                  width: 24.sp,
                  height: 24.sp,
                ),
              ],
            ),
          ),
          rolled
              ? Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.category["items"]!.map<Widget>((item) {
                      return EnrollCategoryField(item: item['item']);
                    }).toList(),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
