import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pki_frontend_app/resizer.dart';

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
  late final data;

  @override
  void initState() {
    super.initState();
    _top = widget.top;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final resp = await http.get(Uri.parse("http://127.0.0.1:8000/get_goods/"));
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

  void clear() {

  }

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
            height: 20000,
            child: Scaffold(
              body: Column(
                children: _text != ''
                ? [
                  Text(
                    _text
                  )
                ]
                : data["data"]!.map<Widget>((category) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['category']
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: category["items"]!.map<Widget>((item) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['item']
                                    )
                                  ],
                                );
                              }
                            ).toList(),
                          )
                        )
                      ],
                    );
                  }
                ).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}