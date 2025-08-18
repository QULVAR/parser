import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'resizer.dart';

class AppText {
  AppText._();

  static const _rubik = TextStyle(fontFamily: 'Rubik');

  static final menuBody16W400 = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: (20/16),
    letterSpacing: 0,
    color: Color(0xFF777777)
  );

  static final menuBody14W400 = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1,
    letterSpacing: 0,
    color: Color(0xFF404040)
  );

  static final loginHeader = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    height: (22/18),
    letterSpacing: 0,
    color: Color(0xFF404040)
  );

  static final addProgramFormHeader = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 20.sp,
    height: 1,
    letterSpacing: 0.0,
  );

  static final addProgramFormFieldsText = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14.sp,
    height: 1.0,
    letterSpacing: 0.0,
  );

  static final addProgramDialog20W500 = _rubik.copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    color: Color(0xFF4DABEE)
  );

  static final addProgramDialo14W400 = _rubik.copyWith(
    fontSize: 14.sp,
    height: (18/14),
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: Color(0xFF777777),
  );

  static final addProgramHowItWorksH1 = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: (20 / 14),
    color: Color(0xFF3E4E5E),
  );

  static final addProgramHowItWorksText = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
    color: Color(0xFF777777),
  );

  static final buttonText16W400 = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    fontStyle: FontStyle.normal,
    height: 1.25,
    letterSpacing: 0.0,
    color: Colors.white,
  );

  static final calendarPopUpViewHeader = _rubik.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 13.sp,
    height: (18/13),
    letterSpacing: -0.08,
    color: Color(0x3C3C434D)
  );

  static final calendarPopUpViewNumbers = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 20.sp,
    height: (24/20),
    letterSpacing: 0.38,
  );

  static final calendarTimePopUp = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 22.sp,
    height: (28/22),
    letterSpacing: 0.35,
    color: Color(0xFF404040)
  );

  static final dropDownButtonPlaceholder = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 16.sp,
    color: Color.fromARGB(255, 167, 167, 167)
  );
  
  static final dropDownButtonItem = _rubik.copyWith(
    fontSize: 16.sp,
    height: 1,
    fontWeight: FontWeight.w400
  );

  static final emailFieldText = _rubik.copyWith(
    fontSize: 16.sp,
    height: (20/16),
    letterSpacing: 0,
  );

  static final loginFormTex14W300 = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14.sp,
    height: (18/14),
    letterSpacing: 0,
    color: Color(0xFF404040)
  );

  static final menuShowDialogButtons = _rubik.copyWith(
    color: CupertinoColors.activeBlue,
    fontSize: 17.sp,
  );

  static final programControlDataViewerText = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
    height: 1,
    letterSpacing: 0,
    color: Color(0xFF404040)
  );

  static final programControlFormText = _rubik.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14.sp,
    height: 1.0,
    letterSpacing: 0.0,
  );

  static final statisticsNumberGeneratorFields = _rubik.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 1,
    letterSpacing: 0,
    color: Color(0xFF404040)
  );
}

extension TxtX on BuildContext {
  TextStyle menuBody16W400([Color? c]) => AppText.menuBody16W400.copyWith(color: c);
  TextStyle addProgramHowItWorksText([double? height]) => AppText.addProgramHowItWorksText.copyWith(height: height);
  TextStyle addProgramDialog20W500([double? height]) => AppText.addProgramDialog20W500.copyWith(height: height);
  TextStyle calendarPopUpViewNumbers([Color? c, FontWeight? fontWeight]) => AppText.calendarPopUpViewNumbers.copyWith(color: c, fontWeight: fontWeight);
  TextStyle emailFieldText(Color c, FontWeight fontWeight) => AppText.emailFieldText.copyWith(color: c, fontWeight: fontWeight);
  TextStyle dropDownButtonPlaceholder(Color c) => AppText.dropDownButtonPlaceholder.copyWith(color: c);
  TextStyle menuShowDialogButtons(FontWeight f) => AppText.menuShowDialogButtons.copyWith(fontWeight: f);
  TextStyle programControlDataViewerText([FontWeight? f, double? s]) => AppText.programControlDataViewerText.copyWith(fontWeight: f, fontSize: s);
  TextStyle addProgramFormHeader(Color c) => AppText.addProgramFormHeader.copyWith(color: c);
  TextStyle dropDownButtonItem(Color c) => AppText.dropDownButtonItem.copyWith(color: c);
}