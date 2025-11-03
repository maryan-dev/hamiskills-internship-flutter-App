import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_item_model.dart';
import '../model/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get taxRate => 0.05; // 5% tax

  double get tax {
    return subtotal * taxRate;
  }

  double get discount {
    if (subtotal > 50) {
      return subtotal * 0.10; // 10% discount if total > $50
    }
    return 0.0;
  }

  double get discountRate {
    if (subtotal > 50) {
      return 0.10; // 10% discount
    }
    return 0.0;
  }

  double get totalAmount {
    return subtotal + tax - discount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    
    notifyListeners();
    _saveCart();
  }

  // Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _saveCart();
  }

  // Increase quantity
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      _saveCart();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _saveCart();
    }
  }

  // Clear all items (this method is now overridden below)

  // Save cart to SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) => item.toJson()).toList();
    await prefs.setString('cart', json.encode(cartData));
  }

  // Load cart from SharedPreferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');
    
    if (cartString != null) {
      final List<dynamic> cartData = json.decode(cartString);
      _items = cartData
          .map((item) => CartItem.fromJson(item, dummyProducts))
          .whereType<CartItem>()
          .toList();
      notifyListeners();
    }
  }

  // Track sales data for dashboard (call this when order is confirmed)
  Future<void> saveSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentSales = prefs.getDouble('total_sales') ?? 0.0;
    await prefs.setDouble('total_sales', currentSales + totalAmount);
    
    // Track most added items
    for (var item in _items) {
      final key = 'product_${item.product.id}_count';
      final currentCount = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, currentCount + item.quantity);
    }
  }

  // Get total sales
  Future<double> getTotalSales() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('total_sales') ?? 0.0;
  }

  // Get product count
  Future<int> getProductCount(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('product_${productId}_count') ?? 0;
  }

  // Clear sales data (for testing/reset)
  Future<void> clearSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('total_sales');
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith('product_') && key.endsWith('_count')) {
        await prefs.remove(key);
      }
    }
  }

  // Clear all items
  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}





