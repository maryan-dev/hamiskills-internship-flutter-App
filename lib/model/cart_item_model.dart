import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  // Convert to Map for SharedPreferences

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }

  static CartItem? fromJson(Map<String, dynamic> json, List<Product> products) {
    final product = products.firstWhere(
      (p) => p.id == json['productId'],
      orElse: () => products.first,
    );
    return CartItem(
      product: product,
      quantity: json['quantity'] ?? 1,
    );
  }
}



