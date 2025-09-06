import 'package:flutter/material.dart';
import 'package:pki_frontend_app/cart.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'package:pki_frontend_app/switch.dart';

class CartPageItem extends StatefulWidget {
  final item;

  const CartPageItem ({
    super.key,
    required this.item
  });

  @override
  State<CartPageItem> createState() => CartPageItemState();
}

class CartPageItemState extends State<CartPageItem> {
  
  final _switcherKey = GlobalKey<SwitcherState>();

  void onPress(bool isOn) {
    final String condition = !isOn ? '1' : '0';
    Cart.updateItemCondition(widget.item[0], widget.item[1], condition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.item[1],
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Colors.black
          ),
        ),
        widget.item[2] != ''
        ? SizedBox(
          width: 335.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.item[2],
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: Colors.grey
                  ),
                ),
              ),
              Switcher(
                key: _switcherKey,
                height: 17.75.h,
                width: 35.5.w,
                onPress: onPress
              ),
            ],
          )
        )
        : SizedBox(),
        Container(
          width: 335.w,
          height: 1,
          margin: EdgeInsets.only(top: 1.sp, bottom: 1.sp),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 203, 203, 203)
          ),
        ),
      ]
    );
  }
}
