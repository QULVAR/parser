import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pki_frontend_app/resizer.dart';

class DiscountTextField extends StatefulWidget {

  const DiscountTextField({super.key});

  @override
  State<DiscountTextField> createState() => DiscountTextFieldState();

}

class DiscountTextFieldState extends State<DiscountTextField> {

  final TextEditingController _controller = TextEditingController();
  final _dateFormatter = MaskTextInputFormatter(
    mask: '## %',
    filter: { "#": RegExp(r'\d') },
  );
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        color: Color(0xFFBCBCBC)
      ),
      width: 15.w,
      height: 10.w,
      padding: EdgeInsets.all(5.sp),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        inputFormatters: [_dateFormatter],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '100%',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            height: (20/16),
            letterSpacing: 0,
            color: Color(0xFFA7A7A7)
          ),
          hintFadeDuration: Duration(milliseconds: 300),
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.sp,
          color: Color(0xFF585858)
        ),
      )
    );
  }
}