class Cart {
  static List<List<String>> userCart = [];

  static void addToCart(String category, String item) {
    userCart.add([category, item]);
  }

  static void removeFromCart(String category, String item) {
    userCart.remove([category, item]);
  }

  static List<List<String>> getCart() {
    return userCart;
  }
}
