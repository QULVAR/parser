import 'package:flutter/material.dart';
import 'dart:math' as math;

double kW = 1.0, kH = 1.0, s = 1.0;

void initScale(BuildContext context) {
  final mq = MediaQuery.of(context);
  final size = mq.size;
  kW = size.width / 390.0;
  kH = size.height / 844.0;
  s  = math.min(kW, kH);
}

extension SizerNum on num {
  double get w  => this * kW;    //width
  double get h  => this * kH;    //height
  double get sp => this * s;     //safe
}