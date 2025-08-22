import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'enroll_category.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final double top;
  const HomePage({super.key, required this.top, required this.logout});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late double _top;
  String _text = "Загружаю...";
  late dynamic data;
  final TextEditingController _searchController = TextEditingController();
  bool fetchSearchDataFlag = false;
  String _lastText = '';

  @override
  void initState() {
    super.initState();
    _top = widget.top;
    _searchController.addListener(() {
      String searchInput = _searchController.text;
      if (searchInput == _lastText) return;
      _lastText = searchInput;
      if (searchInput.isNotEmpty) {
        _fetchSearch(searchInput);
      } else {
        _fetchAll();
      }
    });
  }

  final http.Client _client = http.Client();
  int _reqToken = 0;

  Future<void> _fetchAll() async {
    final token = ++_reqToken;
    setState(() {
      _text = 'Загружаю...';
    });

    final resp = await _client.get(
      Uri.parse('http://127.0.0.1:8000/get_goods/'),
    );

    if (token != _reqToken) return;

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
      _text = 'Загружаю...';
    });

    final resp = await _client.get(
      Uri.parse('http://127.0.0.1:8000/search?query=$q'),
    );

    if (token != _reqToken) return;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAll();
  }

  void clear() {}

  void moveToY(double top) {
    setState(() => _top = top);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuint,
          top: _top,
          left: 0,
          child: SizedBox(
            width: 390.w,
            height: 844.h,
            child: Scaffold(
              body: Column(
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
                        hintText: 'Sony',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 160, 160, 160),
                          fontSize: 16.sp,
                        ),
                        hintFadeDuration: Duration(milliseconds: 300),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(
                    height: 804.h,
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
                            children: [Text(_text)],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
