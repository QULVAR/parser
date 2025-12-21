import 'package:flutter/material.dart';
import 'resizer.dart';

class AdminFile extends StatefulWidget {
  const AdminFile({super.key});

  @override
  State<AdminFile> createState() => AdminFileState();
}

class AdminFileState extends State<AdminFile> {

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Сюда будем грузить файлик")
        ],
      ),
    );
  }
}