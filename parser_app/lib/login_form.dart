import 'package:flutter/material.dart';

import 'email_field.dart';
import 'password_field.dart';
import 'resizer.dart';
import 'text_styles.dart';


class LoginForm extends StatefulWidget {
  final Function authorize;

  const LoginForm({
    super.key,
    required this.authorize,
  });

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String _email = '', _password = '';
  final _emailKey = GlobalKey<EmailInputWidgetState>();
  final _passwordKey = GlobalKey<PasswordInputWidgetState>();
  Color backgroundButtonColor = Color(0xFFE6E6E6);
  bool isFormValid = false;

  void _onEmailChanged(String? email) {
    _email = email ?? '';
    checkFormSetState();
  }

  void _onPasswordChanged(String? password) {
    _password = password ?? '';
    checkFormSetState();
  }

  void clear() {
    _emailKey.currentState?.clear();
    _passwordKey.currentState?.clear();
  }

  void checkFormSetState() {
    isFormValid = _email != '' && _password != '';
    if (isFormValid) {
      setState(() {
        backgroundButtonColor = Color(0xFF4DABEE);
      });
    }
    else {
      setState(() {
        backgroundButtonColor = Color(0xFFE6E6E6);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 342.w,
      height: 233.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-mail',
            textAlign: TextAlign.left,
            style: AppText.loginFormTex14W300,
          ),
          SizedBox(height: 8.h),
          EmailInputWidget(
            key: _emailKey,
            onFilledChanged: _onEmailChanged
          ),
          SizedBox(height: 16.h),
          Text(
            'Пароль',
            textAlign: TextAlign.left,
            style: AppText.loginFormTex14W300,
          ),
          SizedBox(height: 8.h),
          PasswordInputWidget(
            key: _passwordKey,
            onFilledChanged: _onPasswordChanged
          ),
          SizedBox(height: 20.h),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 342.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: backgroundButtonColor,
              borderRadius: BorderRadius.circular(10.sp)
            ),
            child:TextButton(
              key: Key('$backgroundButtonColor'),
              onPressed: () => isFormValid ? widget.authorize(_email, _password) : null,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                fixedSize: Size(342.w, 48.h),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Войти',
                style: AppText.buttonText16W400,
                textAlign: TextAlign.start,
              )
            )
          )
        ]
      )
    );
  }
}