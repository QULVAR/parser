import 'package:flutter/material.dart';
import 'package:pki_frontend_app/cart.dart';
import 'package:pki_frontend_app/cart_page.dart';
import 'package:pki_frontend_app/catalog.dart';
import 'package:pki_frontend_app/profile.dart';
import 'package:pki_frontend_app/resizer.dart';
import 'package:pki_frontend_app/tint_container.dart';
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
  final _profilePageKey = GlobalKey<ProfileState>();
  final _cartPageKey = GlobalKey<CartPageState>();
  final _tintPageKey1 = GlobalKey<TintContainerState>();
  final _appBarKey = GlobalKey<CustomAppBarState>();
  bool flagAnimation = false;
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _top = widget.top;
    Cart.cartPageKey = _cartPageKey;
  }

  void getGoods() {
    _catalogPageKey.currentState?.fetchAll();
  }

  void clear() {}

  void changePage(int selectedPage) {
    switch (selectedPage) {
      case 0:
        flagAnimation = true;
        _profilePageKey.currentState?.moveToX(-390.w);
        _cartPageKey.currentState?.moveToX(390.w);
        _tintPageKey1.currentState?.changeOpacity(0);
        _appBarKey.currentState?.changePage(0);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (flagAnimation) {
            _tintPageKey1.currentState?.moveToX(-390.w);
          }
          flagAnimation = false;
        });
        break;
      case 1:
        flagAnimation = false;
        _tintPageKey1.currentState?.changeOpacity(120);
        _tintPageKey1.currentState?.moveToX(0);
        _appBarKey.currentState?.changePage(1);
        _cartPageKey.currentState?.moveToX(390.w);
        _profilePageKey.currentState?.getProfileData();
        _profilePageKey.currentState?.moveToX(0);
        break;
      case 2:
        flagAnimation = false;
        _tintPageKey1.currentState?.changeOpacity(120);
        _tintPageKey1.currentState?.moveToX(0);
        _appBarKey.currentState?.changePage(2);
        _profilePageKey.currentState?.moveToX(-390.w);
        _cartPageKey.currentState?.getUserCart();
        _cartPageKey.currentState?.moveToX(0);
        break;
    }
  }

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
              appBar: CustomAppBar(
                key: _appBarKey,
                height: 70.h,
                changePage: changePage,
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 239, 239)
                ),
                child: Stack(
                  children:[
                    Catalog(key: _catalogPageKey),
                    TintContainer(
                      key: _tintPageKey1,
                      gestureAction: () {
                        changePage(0);
                      },
                      height: 740.h,
                      width: 390.w,
                    ),
                    Profile(key: _profilePageKey, logout: widget.logout,),
                    CartPage(key: _cartPageKey)
                  ]
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
}
