import 'package:flutter/material.dart';
import 'resizer.dart';
import 'auth.dart';

class AdminFile extends StatefulWidget {
  const AdminFile({super.key});

  @override
  State<AdminFile> createState() => AdminFileState();
}

class AdminFileState extends State<AdminFile> {


  Future<void> buttonPress() async {
    try {
      final result = await Api.I.uploadCatalogExcel();

      if (result['status'] == 'cancelled') {
        return;
      }

      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.circular(8.sp)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Каталог",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              fontStyle: FontStyle.normal,
              height: 1.25,
              letterSpacing: 0.0,
              color: Colors.black,
            )
          ),
          SizedBox(
            height: 7.h,
          ),
          TextButton(
            onPressed: () {
              buttonPress();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(342.w, 44.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 342.w,
              height: 44.h,
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 158, 58),
                borderRadius: BorderRadius.circular(10.sp)
              ),
              child: Text(
                'Загрузить excel (.xlsx)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontStyle: FontStyle.normal,
                  height: 1.25,
                  letterSpacing: 0.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}