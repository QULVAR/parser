import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'auth.dart';
import 'resizer.dart';
import 'widgets.dart';

class AdminPromoItem extends StatefulWidget {

  final String promo;
  final String percent;
  final Widget divideLine;
  final Future<void> Function() reloadPromos;
  

  const AdminPromoItem({
    super.key,
    required this.promo,
    required this.percent,
    required this.divideLine,
    required this.reloadPromos,
  });

  @override
  State<AdminPromoItem> createState() => AdminPromoItemState();
}

class AdminPromoItemState extends State<AdminPromoItem> {

  String activeIconEdit = "pen";
  bool setUpTextPromo = true;
  bool setUpTextPercent = true;

  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final _percentFormatter = MaskTextInputFormatter(
    mask: '##',
    filter: {"#": RegExp(r'\d')},
  );
  String editedPromo = "";
  String promoText = "";
  int percents = 0;

  @override
  void initState() {
    super.initState();
    _promoController.addListener(() {
      promoText = _promoController.text;
      print(promoText);
    });

    _percentController.addListener(() {
      final percentsRaw = _percentFormatter.getUnmaskedText();
      if (percentsRaw != "") {
        percents = int.parse(percentsRaw);
      }
      else {
        percents = 0;
      }
      print(percents);
    });
    setUpWidget();
  }

  void setUpWidget() {
    if (setUpTextPromo) {
      _promoController.value = TextEditingValue(text: widget.promo);
      setUpTextPromo = false;
    }
    if (setUpTextPercent) {
      _percentFormatter.clear();
      final formatted = _percentFormatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: widget.percent),
      );
      _percentController.value = formatted;
      setUpTextPercent = false;
    }
  }

  final oneRowHeight = 30.h;
  final tableWidth = 270.w;
  bool formStateEdit = false;

  void changeFormState() {
    if (formStateEdit) {
      setState(() {
        activeIconEdit = "check";
        editedPromo = promoText;
      });
    }
    else {
      setState(() {
        activeIconEdit = "pen";
      });
    }
  }

  void clearIfInitialEmpty() {
    final promoIn = widget.promo.trim();
    final percentIn = widget.percent.trim();

    if (promoIn.isEmpty && percentIn.isEmpty) {
      _promoController.text = "";
      _percentFormatter.clear();
      _percentController.text = "";

      promoText = "";
      editedPromo = "";
      percents = 0;

      setUpTextPromo = false;
      setUpTextPercent = false;
    }
  }

  Future<void> updatePromos() async {
    final resp = await Api.I.updatePromo(editedPromo, promoText, percents.toString());
    if (!mounted) return;
    final promos_resp = resp;
    if (promos_resp["status"] == "error") {
      print("error");
    }
    else {
      print("success");
    }
    widget.reloadPromos();
    clearIfInitialEmpty();
  }

  Future<void> deletePromos() async {
    final resp = await Api.I.deletePromo(promoText);
    if (!mounted) return;
    final promos_resp = resp;
    if (promos_resp["status"] == "error") {
      print("error");
    }
    else {
      print("success");
    }
    widget.reloadPromos();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalDividingLine(oneRowHeight),
            Container(
              width: 139.w,
              height: oneRowHeight,
              alignment: Alignment.center,
              child: formStateEdit
              ? TextField(
                controller: _promoController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 0),
                  hintText: 'Promo',
                  hintStyle: null,
                  hintFadeDuration: Duration(milliseconds: 300)
                ),
                style: TextStyle(
                  fontSize: 15
                ),
                textAlign: TextAlign.center,
              )
              : Text(
                _promoController.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                  ),
              ),
            ),
            verticalDividingLine(oneRowHeight),
            Container(
              width: 66.w,
              height: oneRowHeight,
              alignment: Alignment.center,
              child: formStateEdit
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30.w,
                    height: oneRowHeight,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _percentController,
                      inputFormatters: [_percentFormatter],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(bottom: 0),
                        hintText: '5',
                        hintStyle: null,
                        hintFadeDuration: Duration(milliseconds: 300)
                      ),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                  ),
                  Text("%")
                ],
              ) 
              : Text(
                "${_percentController.text} %",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15
                ),
              ),
            ),
            verticalDividingLine(oneRowHeight),
            Container(
              height: oneRowHeight,
              width: 30.w,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  if (activeIconEdit == "check") {
                    updatePromos();
                  }
                  formStateEdit = !formStateEdit;
                  changeFormState();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Image.asset('assets/icons/$activeIconEdit.png', width: 20.sp, height: 20.sp),
              ),
            ),
            verticalDividingLine(oneRowHeight),
            Container(
              height: oneRowHeight,
              width: 30.w,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  if (promoText != "") {
                    deletePromos();
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Image.asset('assets/icons/bin.png', width: 18.sp, height: 18.sp),
              ),
            ),
            verticalDividingLine(oneRowHeight)
          ],
        ),
        widget.divideLine
      ],
    );
  }
}