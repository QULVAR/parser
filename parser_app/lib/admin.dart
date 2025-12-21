import 'package:flutter/material.dart';
import 'admin_file.dart';
import 'admin_promo.dart';
import 'admin_accounts.dart';
import 'resizer.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => AdminState();
}

class AdminState extends State<Admin> {
  double _left = -390.w;

  void moveToX (double left) {
    setState(() {
      _left = left;
    });
  }

  @override
  Widget build(BuildContext context) {

    final adminFilePageKey = GlobalKey<AdminFileState>();
    final adminPromoPageKey = GlobalKey<AdminPromoState>();
    final adminAccountsPageKey = GlobalKey<AdminAccountsState>();

    return AnimatedPositioned(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AdminFile(
              key: adminFilePageKey,
            ),
            SizedBox(height: 20.h,),
            AdminPromo(
              key: adminPromoPageKey,
            ),
            SizedBox(height: 20.h,),
            AdminAccounts(
              key: adminAccountsPageKey,
            ),
          ],
        ),
      )
    );
  }
}