import 'package:flutter/material.dart';
import 'auth.dart';
import 'admin_promo_item.dart';
import 'widgets.dart';
import 'resizer.dart';

class AdminPromo extends StatefulWidget {
  const AdminPromo({super.key});

  @override
  State<AdminPromo> createState() => AdminPromoState();
}

class AdminPromoState extends State<AdminPromo> {

  var promos = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> loadPromos() async {
    final resp = await Api.I.getPromos();
    if (!mounted) return;
    final promos_resp = resp;
    var promos_list = [];
    for (var key in promos_resp.keys) {
      promos_list.add([key, promos_resp[key]]);
    }
    promos_list.add(["", ""]);
    setState(() {
      promos = promos_list;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPromos();
  }

  final oneRowHeight = 30.h;
  final tableWidth = 270.w;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 200.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.circular(8.sp)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          horizontalDividingLine(tableWidth),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              verticalDividingLine(oneRowHeight),
              Container(
                width: 139.w,
                height: oneRowHeight,
                alignment: Alignment.center,
                child: Text(
                  "Промокод",
                  textAlign: TextAlign.center,
                ),
              ),
              verticalDividingLine(oneRowHeight),
              Container(
                width: 66.w,
                height: oneRowHeight,
                alignment: Alignment.center,
                child: Text(
                  "Скидка",
                  textAlign: TextAlign.center,
                ),
              ),
              verticalDividingLine(oneRowHeight),
              SizedBox(width: 30.w,),
              verticalDividingLine(oneRowHeight),
              SizedBox(width: 30.w,),
              verticalDividingLine(oneRowHeight)
            ],
          ),
          horizontalDividingLine(tableWidth),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: promos.isNotEmpty
              ? promos.map<Widget>(
                  (item) => AdminPromoItem(
                    key: ValueKey('${item[0]}|${item[1]}'),
                    promo: item[0],
                    percent: "${item[1]}",
                    divideLine: horizontalDividingLine(tableWidth),
                  ),
                ).toList()
              : [Text('')]
            ),
          ),
        ],
      )
    );
  }
}