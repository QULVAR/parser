import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.initialPage = 0,
    required this.height,
    required this.changePage
  });
  final int initialPage;
  final double height;
  final void Function(int) changePage;

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomAppBarState extends State<CustomAppBar> {
  late int page;

  Color activeFieldColor = Color.fromARGB(30, 0, 158, 58);
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    page = widget.initialPage;
  }

  void changePage(int page) {
    setState(() {
      selectedPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: widget.height,
      title: SizedBox(
        height: 70.h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 140.w,
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              decoration:BoxDecoration(
                color: selectedPage == 0 ? activeFieldColor : Colors.transparent,
                borderRadius: BorderRadius.circular(25.sp)
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedPage = 0;
                  });
                  widget.changePage(selectedPage);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset('assets/icons/logo.png', width: 28.sp, height: 28.sp),
                      SizedBox(width: 6.w),
                      Text('Амерта', style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                    ]),
                    SizedBox(height: 5.h,),
                    Text('Каталог', style: TextStyle(fontSize: 16.sp, color: Color.fromARGB(255, 127, 127, 127))),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              left: 0, right: null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 90.w,
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  decoration:BoxDecoration(
                    color: selectedPage == 1 ? activeFieldColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(25.sp)
                  ),
                  child: TextButton(
              onPressed: () {
                setState(() {
                  selectedPage = 1;
                });
                widget.changePage(selectedPage);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shadowColor: Colors.transparent,
                overlayColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset('assets/icons/profile.png', width: 28.sp, height: 28.sp),
                  ]),
                  SizedBox(height: 5.h,),
                  Text('Профиль', style: TextStyle(fontSize: 16.sp, color: Color.fromARGB(255, 127, 127, 127))),
                ],
              ),
            ),
            )
              ),
            ),
            Positioned.fill(
              right: 0, left: null,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 90.w,
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  decoration:BoxDecoration(
                    color: selectedPage == 2 ? activeFieldColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(25.sp)
                  ),
                  child: TextButton(
              onPressed: () {
                setState(() {
                  selectedPage = 2;
                });
                widget.changePage(selectedPage);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shadowColor: Colors.transparent,
                overlayColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset('assets/icons/cart.png', width: 28.sp, height: 28.sp),
                  ]),
                  SizedBox(height: 5.h,),
                  Text('Корзина', style: TextStyle(fontSize: 16.sp, color: Color.fromARGB(255, 127, 127, 127))),
                ],
              ),
            ),
            )
              ),
            ),
          ],
        ),
      ),
    );
  }
}