import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'enroll_category.dart';
import 'auth.dart';

class Catalog extends StatefulWidget {
  Catalog({super.key});

  @override
  State<Catalog> createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  String _text = "Загружаю...";
  late dynamic data;
  final TextEditingController _searchController = TextEditingController();
  bool fetchSearchDataFlag = false;
  String _lastText = '';

  int _reqToken = 0;

  Future<void> fetchAll() async {
    final token = ++_reqToken;
    setState(() {
      _text = 'Загрузка...';
    });

    final resp = await Api.I.authedGet('/api/get_goods/');

    if (token != _reqToken) return;
    if (resp.statusCode == 401) {
      setState(() {
        _text = 'Нужно войти, дружок-пирожок';
      });
      return;
    }
    if (resp.statusCode == 200) {
      final dataLocal = jsonDecode(resp.body);
      setState(() {
        data = dataLocal;
        _text = '';
      });
    } else {
      setState(() {
        _text = 'Ошибка: ${resp.statusCode}';
        data = {};
      });
    }
  }

  Future<void> _fetchSearch(String q) async {
    final token = ++_reqToken;
    setState(() {
      _text = 'Загрузка...';
    });

    final resp = await Api.I.authedGet('/api/search/', query: {'query': q});

    if (token != _reqToken) return;

    if (resp.statusCode == 401) {
      setState(() {
        _text = 'Нужно войти';
      });
      return;
    }
    if (resp.statusCode == 200) {
      final dataLocal = jsonDecode(resp.body);
      setState(() {
        data = dataLocal;
        _text = '';
      });
    } else {
      setState(() {
        _text = 'Ошибка: ${resp.statusCode}';
        data = {};
      });
    }
  }

  void clear() {}

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      String searchInput = _searchController.text;
      if (searchInput == _lastText) return;
      _lastText = searchInput;
      if (searchInput.isNotEmpty) {
        _fetchSearch(searchInput);
      } else {
        fetchAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 844.h,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Container(
            width: 370.w,
            height: 30.h,
            margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 204, 204, 204),
              borderRadius: BorderRadius.circular(6.sp),
            ),
            padding: EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5.h),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.only(bottom: 0),
                hintText: 'Найди что нужно',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 160, 160, 160),
                  fontSize: 16.sp,
                ),
                hintFadeDuration: Duration(milliseconds: 300),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.sp),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            margin: EdgeInsets.only(top: 10.h, bottom: 0.h),
            height: 656.h,
            child: _text == ''
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      top: 10.h,
                      bottom: 10.h,
                      right: 10.w,
                      left: 10.w,
                    ),
                    itemCount: (data["data"] as List).length,
                    itemBuilder: (context, i) {
                      return EnrollCategory(category: data["data"][i]);
                    },
                  )
                : ListView(
                    padding: EdgeInsets.only(
                      top: 10.h,
                      bottom: 10.h,
                      right: 10.w,
                      left: 10.w,
                    ),
                    children: [
                      Center(
                        child: Text(_text, style: TextStyle(fontSize: 18.sp)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
