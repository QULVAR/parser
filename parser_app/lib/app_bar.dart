import 'package:flutter/widgets.dart';
import 'package:pki_frontend_app/resizer.dart';

class AppBar extends StatefulWidget {
  final Map<String, dynamic> category;
  const AppBar({super.key, required this.category});

  @override
  State<AppBar> createState() => AppBarState();
}

class AppBarState extends State<AppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
