import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

class CartPageItemAmount extends StatefulWidget {
  final Function onPress;
  final int amount;

  const CartPageItemAmount ({
    super.key,
    required this.onPress,
    required this.amount
  });

  @override
  State<CartPageItemAmount> createState() => CartPageItemAmountState();
}

class CartPageItemAmountState extends State<CartPageItemAmount> {

  late int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
  }

  @override
  void didUpdateWidget(CartPageItemAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount) {
      amount = widget.amount; // синхронизируем локальное состояние
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.sp,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                if (amount <= 1) {
                  widget.onPress('--'); // удаление позиции
                  return;
                }
                amount -= 1;
                widget.onPress('-');
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shadowColor: Colors.transparent,
              overlayColor: Colors.transparent,
            ),
            child: Image.asset('assets/icons/minus.png', width: 14.sp, height: 14.sp),
          ),
          Expanded(
            child: Text(
              amount.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.black
              ),
            )
          ),
          TextButton(
            onPressed: () {
              setState(() {
                amount += 1;
                widget.onPress('+');
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shadowColor: Colors.transparent,
              overlayColor: Colors.transparent,
            ),
            child: Image.asset('assets/icons/plus.png', width: 14.sp, height: 14.sp),
          ),
        ],
      )
    );
  }
}
