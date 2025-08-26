import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.initialPage = 0, required this.height});
  final int initialPage;
  final double height;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomAppBarState extends State<CustomAppBar> {
  late int page;

  @override
  void initState() {
    super.initState();
    page = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: widget.height,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                page = 0;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5.h,),
                Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  width: 40.sp,
                  height: 40.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  'Амерта',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Text('Каталог',
            style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
            ),)
              ]
            )
          ),
        ],
      ),
    );
  }
}