import 'package:flutter/material.dart';
import 'auth.dart';
import 'switch.dart';
import 'resizer.dart';
import 'widgets.dart';
import 'app_message_box.dart';

class AdminAccountsItem extends StatefulWidget {
  final String email;
  final bool admin;
  final Widget divideLine;
  final Future<void> Function() reloadAccounts;

  const AdminAccountsItem({
    super.key,
    required this.email,
    required this.admin,
    required this.divideLine,
    required this.reloadAccounts,
  });

  @override
  State<AdminAccountsItem> createState() => AdminAccountsItemState();
}

class AdminAccountsItemState extends State<AdminAccountsItem> {
  String activeIconEdit = "pen";
  bool setUpTextEmail = true;
  bool setUpTextPassword = true;
  bool setUpAdmin = true;

  final _switcherKey = GlobalKey<SwitcherState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String editedAccount = "";
  String emailText = "";
  String newPassword = "";
  bool isAdmin = false;

  final oneRowHeight = 30.h;
  final tableWidth = 270.w;

  bool formStateEdit = false;
  bool isCheckboxEnabled = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      emailText = _emailController.text;
      print(emailText);
    });

    _passwordController.addListener(() {
      newPassword = _passwordController.text;
      print(newPassword);
    });

    setUpWidget();
  }

  void setUpWidget() {
    if (setUpTextEmail) {
      _emailController.value = TextEditingValue(text: widget.email);
      emailText = widget.email;
      editedAccount = widget.email;
      setUpTextEmail = false;
    }

    if (setUpTextPassword) {
      _passwordController.value = const TextEditingValue(text: "");
      newPassword = "";
      setUpTextPassword = false;
    }

    if (setUpAdmin) {
      isAdmin = widget.admin;
      setUpAdmin = false;
    }
  }

  void changeFormState() {
    if (formStateEdit) {
      setState(() {
        activeIconEdit = "check";
        isCheckboxEnabled = true;
      });
    } else {
      setState(() {
        activeIconEdit = "pen";
        isCheckboxEnabled = false;
      });
    }
  }

  void clearIfInitialEmpty() {
    final emailIn = widget.email.trim();

    if (emailIn.isEmpty) {
      _emailController.text = "";
      _passwordController.clear();

      emailText = "";
      editedAccount = "";
      newPassword = "";
      isAdmin = false;

      setUpTextEmail = false;
      setUpTextPassword = false;
      setUpAdmin = false;
    }
  }

  void _onPressed(bool isOnCheckBox) {
    setState(() {
      isAdmin = !isOnCheckBox;
    });
  }

  Future<void> updateAccounts() async {
    final resp = editedAccount.trim().isEmpty
        ? await Api.I.createAccount(emailText, newPassword, isAdmin)
        : await Api.I.updateAccount(
            editedAccount,
            emailText,
            newPassword,
            isAdmin,
          );

    if (!mounted) return;

    final accountsResp = resp;
    if (accountsResp["status"] == "error") {
      await showAppMessageBox(
        context,
        title: 'Ошибка',
        message: 'Произошла ошибка',
      );
      return;
    }

    await widget.reloadAccounts();
    clearIfInitialEmpty();
  }

  Future<void> deleteAccount() async {
    final resp = await Api.I.deleteAccount(editedAccount);
    if (!mounted) return;

    final accountsResp = resp;
    if (accountsResp["status"] == "error") {
      await showAppMessageBox(
        context,
        title: 'Ошибка',
        message: 'Произошла ошибка',
      );
      return;
    }

    await widget.reloadAccounts();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setUpWidget();
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
              width: 268.w,
              height: oneRowHeight,
              alignment: Alignment.center,
              child: formStateEdit
                  ? TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(bottom: 0),
                        hintText: 'Почта',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(90, 0, 0, 0)
                        ),
                        hintFadeDuration: Duration(milliseconds: 300),
                      ),
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      _emailController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
            ),
            verticalDividingLine(oneRowHeight),
          ],
        ),
        widget.divideLine,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalDividingLine(oneRowHeight),
            Container(
              width: 175.w,
              height: oneRowHeight,
              alignment: Alignment.center,
              child: formStateEdit
                  ? Container(
                      width: 175.w,
                      height: oneRowHeight,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.only(bottom: 0),
                          hintText: 'Новый пароль',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(90, 0, 0, 0)
                          ),
                          hintFadeDuration: Duration(milliseconds: 300),
                        ),
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  : Text(
                      _emailController.text.trim().isEmpty ? "" : "•••••••",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
            ),
            verticalDividingLine(oneRowHeight),
            Container(
              height: oneRowHeight,
              width: 30.w,
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: !isCheckboxEnabled,
                child: Switcher(
                  key: _switcherKey,
                  height: 25.h,
                  width: 25.w,
                  onPress: _onPressed,
                  isOn: isAdmin,
                  animationName: "checkbox",
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
                    updateAccounts();
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
                child: Image.asset(
                  'assets/icons/$activeIconEdit.png',
                  width: 20.sp,
                  height: 20.sp,
                ),
              ),
            ),
            verticalDividingLine(oneRowHeight),
            Container(
              height: oneRowHeight,
              width: 30.w,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () async {
                  if (editedAccount.trim().isNotEmpty) {
                    await showAppMessageBox(
                      context,
                      title: 'Удаление',
                      message: 'Удалить аккаунт?',
                      buttons: AppMessageBoxButtons.cancelOk,
                      onOk: () {
                        deleteAccount();
                      },
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/icons/bin.png',
                  width: 18.sp,
                  height: 18.sp,
                ),
              ),
            ),
            verticalDividingLine(oneRowHeight),
          ],
        ),
        widget.divideLine,
      ],
    );
  }
}