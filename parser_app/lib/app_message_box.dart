import 'package:flutter/material.dart';
import 'resizer.dart';

enum AppMessageBoxButtons {
  ok,
  cancelOk,
}

class AppMessageBox extends StatelessWidget {
  final String title;
  final String message;
  final AppMessageBoxButtons buttons;
  final VoidCallback? onOk;

  const AppMessageBox({
    super.key,
    required this.title,
    required this.message,
    this.buttons = AppMessageBoxButtons.ok,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Container(
        width: 300.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(18.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(255, 210, 210, 210),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.25,
                color: const Color.fromARGB(255, 35, 35, 35),
              ),
            ),
            SizedBox(height: 18.h),
            if (buttons == AppMessageBoxButtons.ok)
              _DialogButton(
                text: 'Ок',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      text: 'Отмена',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _DialogButton(
                      text: 'Да',
                      isPrimary: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onOk?.call();
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color.fromARGB(255, 0, 158, 58)
              : const Color.fromARGB(255, 220, 220, 220),
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

Future<void> showAppMessageBox(
  BuildContext context, {
  required String title,
  required String message,
  AppMessageBoxButtons buttons = AppMessageBoxButtons.ok,
  VoidCallback? onOk,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppMessageBox(
      title: title,
      message: message,
      buttons: buttons,
      onOk: onOk,
    ),
  );
}