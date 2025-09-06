class Cart {
  static List<List<String>> _userCart = [];
  static List<List<String>> _userCartForRequest = [];

  static void addToCart(String category, String item, String price) {
    _userCart.add([category, item, price]);
    _userCartForRequest.add([category, item, '0']);
  }

  static void removeFromCart(String category, String item) {
    _userCart.removeWhere((pair) => pair[0] == category && pair[1] == item);
    _userCartForRequest.removeWhere((pair) => pair[0] == category && pair[1] == item);
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
}
