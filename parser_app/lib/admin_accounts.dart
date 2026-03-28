import 'package:flutter/material.dart';
import 'auth.dart';
import 'admin_accounts_item.dart';
import 'widgets.dart';
import 'resizer.dart';
import 'app_message_box.dart';

class AdminAccounts extends StatefulWidget {
  const AdminAccounts({super.key});

  @override
  State<AdminAccounts> createState() => AdminAccountsState();
}

class AdminAccountsState extends State<AdminAccounts> {
  var accounts = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> loadAccounts() async {
    try {
      final resp = await Api.I.getAccounts();
      if (!mounted) return;

      final accountsResp = resp;
      var accountsList = [];

      if (accountsResp["status"] == "success") {
        final list = accountsResp["list"] as List<dynamic>? ?? [];
        for (final item in list) {
          accountsList.add([
            item["email"] ?? "",
            item["is_admin"] ?? false,
          ]);
        }
      } else {
        await showAppMessageBox(
          context,
          title: 'Ошибка',
          message: 'Произошла ошибка',
        );
      }

      accountsList.add(["", false]);

      setState(() {
        accounts = accountsList;
      });
    } catch (_) {
      if (!mounted) return;
      await showAppMessageBox(
        context,
        title: 'Ошибка',
        message: 'Произошла ошибка',
      );
    }
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
      height: 238.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.circular(8.sp),
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
                width: 268.w,
                height: oneRowHeight,
                alignment: Alignment.center,
                child: Text(
                  "Аккаунты",
                  textAlign: TextAlign.center,
                ),
              ),
              verticalDividingLine(oneRowHeight),
            ],
          ),
          horizontalDividingLine(tableWidth),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              verticalDividingLine(oneRowHeight),
              Container(
                width: 268.w,
                height: oneRowHeight,
                alignment: Alignment.center,
                child: Text(
                  "Почта",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              verticalDividingLine(oneRowHeight),
            ],
          ),
          horizontalDividingLine(tableWidth),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              verticalDividingLine(oneRowHeight),
              Container(
                width: 175.w,
                height: oneRowHeight,
                alignment: Alignment.center,
                child: Text(
                  "Новый пароль",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              verticalDividingLine(oneRowHeight),
              Container(
                height: oneRowHeight,
                width: 30.w,
                alignment: Alignment.center,
                child: Text(
                  "Адм",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              verticalDividingLine(oneRowHeight),
              Container(
                height: oneRowHeight,
                width: 30.w,
                alignment: Alignment.center,
                child: Text(""),
              ),
              verticalDividingLine(oneRowHeight),
              Container(
                height: oneRowHeight,
                width: 30.w,
                alignment: Alignment.center,
                child: Text(""),
              ),
              verticalDividingLine(oneRowHeight),
            ],
          ),
          horizontalDividingLine(tableWidth),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: accounts.isNotEmpty ? accounts.length : 0,
                itemBuilder: (context, index) {
                  final item = accounts[index];
                  return AdminAccountsItem(
                    key: ValueKey('${item[0]}_$index'),
                    email: item[0],
                    admin: item[1] == true,
                    divideLine: horizontalDividingLine(tableWidth),
                    reloadAccounts: loadAccounts,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
