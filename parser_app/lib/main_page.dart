import 'package:flutter/material.dart';
import 'package:pki_frontend_app/catalog.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'app_bar.dart';

class HomePage extends StatefulWidget {
  final VoidCallback logout;
  final double top;
  const HomePage({super.key, required this.top, required this.logout});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late double _top;
  final _catalogPageKey = GlobalKey<CatalogState>();

  @override
  void initState() {
    super.initState();
    _top = widget.top;
  }

  void getGoods() {
    _catalogPageKey.currentState?.fetchAll();
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
              appBar: CustomAppBar(height: 60.h),
              body: Catalog(key: _catalogPageKey),
            ),
          ),
        ),
      ],
    );
  }
}
