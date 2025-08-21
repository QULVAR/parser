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

  @override
  void initState() {
    super.initState();
    _top = widget.top;
    _searchController.addListener(() {
      String searchInput = _searchController.text;
      if (searchInput.isNotEmpty) {
        fetchSearchData(searchInput);
      } else {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    setState(() {
      _text = "Загружаю...";
      data = [];
    });
    try {
      final resp = await http.get(
        Uri.parse("http://127.0.0.1:8000/get_goods/"),
      );
      if (resp.statusCode == 200) {
        final dataLocal = jsonDecode(resp.body);
        setState(() {
          data = dataLocal;
          _text = '';
        });
      } else {
        setState(() {
          _text = "Ошибка: ${resp.statusCode}";
          data = {};
        });
      }
    } catch (e) {
      setState(() => _text = "Исключение: $e");
      data = {};
    }
  }

  Future<void> fetchSearchData(String query) async {
    setState(() {
      _text = "Загружаю...";
      data = [];
    });
    try {
      final resp = await http.get(
        Uri.parse("http://127.0.0.1:8000/search?query=$query"),
      );
      if (resp.statusCode == 200) {
        final dataLocal = jsonDecode(resp.body);
        setState(() {
          data = dataLocal;
          _text = '';
        });
      } else {
        setState(() {
          _text = "Ошибка: ${resp.statusCode}";
          data = {};
        });
      }
    } catch (e) {
      setState(() => _text = "Исключение: $e");
      data = {};
    }
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
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuint,
          top: _top,
          left: 0,
          child: SizedBox(
            width: 390.w,
            height: 844.h,
            child: Scaffold(
              body: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(bottom: 0),
                      hintText: 'Sony',
                      hintFadeDuration: Duration(milliseconds: 300)
                    ),
                  ),
                  SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h,
                    right: 10.w,
                    left: 10.w,
                  ),
                  child: Column(
                    children: _text == ''
                        ? data["data"]!.map<Widget>((category) {
                            return EnrollCategory(category: category);
                          }).toList()
                        : [Text(_text)],
                  ),
                ),
              ),
                ])
            ),
          ),
        ),
      ],
    );
  }
}
