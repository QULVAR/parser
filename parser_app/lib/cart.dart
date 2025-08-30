class Cart {
  static List<List<String>> _userCart = [];

  static void addToCart(String category, String item) {
    _userCart.add([category, item]);
  }

  static void removeFromCart(String category, String item) {
    _userCart.removeWhere((pair) => pair[0] == category && pair[1] == item);
  }

  static List<List<String>> getCart() {
    return _userCart;
  }
}
