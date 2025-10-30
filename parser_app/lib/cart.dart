import 'package:flutter/material.dart';
import 'package:pki_frontend_app/cart_page.dart';

class Cart {
  static List<List<String>> _userCart = [];
  static List<List<String>> _userCartForRequest = [];
  static GlobalKey<CartPageState>? cartPageKey;

  static void addToCart(String category, String item, String price) {
    _userCart.add([category, item, price]);
    _userCartForRequest.add([category, item, '0']);
    if (cartPageKey != null) {
      cartPageKey!.currentState?.buttonColorSelector();
    }
  }

  static void removeFromCart(String category, String item) {
    final i = _userCart.indexWhere((pair) => pair[0] == category && pair[1] == item);
    if (i != -1) _userCart.removeAt(i);
    final j = _userCartForRequest.indexWhere((pair) => pair[0] == category && pair[1] == item);
    if (j != -1) _userCartForRequest.removeAt(j);
    if (cartPageKey != null) {
      cartPageKey!.currentState?.buttonColorSelector();
    }
  }

  static void updateItemCondition(String category, String item, String condition) {
    for (int i = 0; i < _userCartForRequest.length; i++) {
      if ((_userCartForRequest[i][0] == category) && (_userCartForRequest[i][1] == item)) {
        _userCartForRequest[i][2] = condition;
      }
    }
  }

  static List<List<String>> getCart() {
    return _userCart;
  }

  static List<List<String>> getCartRequest() {
    return _userCartForRequest;
  }

  static bool isEmpty() {
    return _userCart.isEmpty;
  }

  static bool isNotEmpty() {
    return _userCart.isNotEmpty;
  }
}
