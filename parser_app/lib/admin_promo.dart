import 'package:flutter/material.dart';
import 'auth.dart';
import 'admin_promo_item.dart';
import 'widgets.dart';
import 'resizer.dart';

class AdminPromo extends StatefulWidget {
  const AdminPromo({
    super.key
  });

  @override
  State<AdminPromo> createState() => AdminPromoState();
}

class AdminPromoState extends State<AdminPromo> {

  var promos = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> loadPromos() async {
    print('loadPromos');
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

  final oneRowHeight = 30.h;
  final tableWidth = 270.w;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 207.h,
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
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: promos.isNotEmpty ? promos.length : 0,
                itemBuilder: (context, index) {
                  final item = promos[index];
                  return AdminPromoItem(
                    key: ValueKey('${item[0]}'),
                    promo: item[0],
                    percent: "${item[1]}",
                    divideLine: horizontalDividingLine(tableWidth),
                    reloadPromos: loadPromos,
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}