import 'package:flutter/material.dart';

Widget verticalDividingLine(double height) {
    return SizedBox(
      width: 1,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black
        )
      ),
    );
  }

  Widget horizontalDividingLine(double width) {
    return SizedBox(
      width: width,
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black
        )
      ),
    );
  }