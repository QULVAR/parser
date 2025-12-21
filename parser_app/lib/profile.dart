import 'package:flutter/material.dart';
import 'auth.dart';
import 'resizer.dart';
import 'tint_container.dart';
import 'admin.dart';

class Profile extends StatefulWidget {
  final VoidCallback logout;
  const Profile({super.key, required this.logout});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  double _left = -390.w;

  String username = 'Загрузка...';
  String email = 'Загрузка...';
  String role = 'Загрузка...';
  final _tintPageKey = GlobalKey<TintContainerState>();
  final _adminPageKey = GlobalKey<AdminState>();

  void moveToX (double left) {
    setState(() {
      _left = left;
    });
  }

  void getProfileData() {
    setState(() {
      Api.I.me().then((Map<String, dynamic> user) {
        setState(() {
          username = user['username'];
          email = user['email'];
          role = user['role'];
        });
      }).catchError((e) {});
    });
  }

  void openAdminPage() {
    _tintPageKey.currentState?.changeOpacity(120);
    _tintPageKey.currentState?.moveToX(0);
    _adminPageKey.currentState?.moveToX(0);  
  }

  void closeAdminPage() {
    bool flagAnimation = true;
    _adminPageKey.currentState?.moveToX(-390.w);
    _tintPageKey.currentState?.changeOpacity(0);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (flagAnimation) {
        _tintPageKey.currentState?.moveToX(-390.w);
      }
      flagAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 20,
          left: _left + 20,
          child: Container(
            width: 350.w,
            height: 600.h,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.sp)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вы вошли как',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.h,),
                Text(
                  'Имя пользователя: $username',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Почта: $email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                (role == "admin")
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 380.h,),
                    TextButton(
                      onPressed: openAdminPage,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      child: Container(
                        height: 40.h,
                        width: 310.w,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 220, 220, 220),
                          borderRadius: BorderRadius.circular(15.sp)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/admin.png', width: 20.sp, height: 20.sp),
                            SizedBox(width: 5.sp,),
                            Text(
                              'Админ панель',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: 10.h,),
                  ],
                )
                : SizedBox(height: 430.h,),
                TextButton(
                  onPressed: widget.logout,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shadowColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  child: Container(
                    height: 40.h,
                    width: 310.w,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 220, 220, 220),
                      borderRadius: BorderRadius.circular(15.sp)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/exit.png', width: 20.sp, height: 20.sp),
                        SizedBox(width: 5.sp,),
                        Text(
                          'Выход',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        ),
        TintContainer(
          key: _tintPageKey,
          gestureAction: () {
            closeAdminPage();
          },
          height: 740.h,
          width: 390.w,
        ),
        Admin(key: _adminPageKey)
      ],
    );
  }

}