import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'resizer.dart';
import 'text_styles.dart';


class PasswordInputWidget extends StatefulWidget {

  final ValueChanged<String?> onFilledChanged;

  const PasswordInputWidget({
    super.key,
    required this.onFilledChanged,
  });

  @override
  State<PasswordInputWidget> createState() => PasswordInputWidgetState();
}

class PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool isFilled = false;
  final TextEditingController _passwordController = TextEditingController();
  String _addedPathToPasswordFieldIcon = '_with_line';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (_passwordController.text.length >= 7) {
        setState(() {
          isFilled = true;
          widget.onFilledChanged(_passwordController.text);
        });
      } else {
        setState(() {
          isFilled = false;
          widget.onFilledChanged(null);
        });
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void clear() {
    setState(() {
      _passwordController.clear();
      widget.onFilledChanged(null);
      isFilled = false;
      _addedPathToPasswordFieldIcon = '_with_line';
      _obscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 342.w,
      height: 48.h,
      padding: EdgeInsets.only(bottom: 14.h, top: 14.h, left: 12.w, right: 0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashRadius: null,
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
                _addedPathToPasswordFieldIcon = _obscureText ? '_with_line' : '';
              });
            },
            icon: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: SvgPicture.asset(
                      'assets/icons/eye$_addedPathToPasswordFieldIcon.svg',
                      key: ValueKey(_addedPathToPasswordFieldIcon),
                      width: 21.sp,
                      height: _addedPathToPasswordFieldIcon != '' ? 18.sp : 16.sp,
                    ),
                );
              },
            ),
          ),
          border: InputBorder.none,
          hintText: 'Ваш пароль',
          hintStyle: context.emailFieldText(Color(0xFFA7A7A7), FontWeight.w300),
          hintFadeDuration: Duration(milliseconds: 300)
        ),
        style: context.emailFieldText(Color(0xFF404040), FontWeight.w400),
        obscureText: _obscureText,
        maxLines: 1,
      ),
    );
  }
}