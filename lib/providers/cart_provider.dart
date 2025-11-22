import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_item_model.dart';
import '../model/product_model.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import '../services/dashboard_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final DashboardService _dashboardService = DashboardService();
  String? _currentUserId;

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
    if (_currentUserId == null) {
      // Don't add items if no user is logged in
      return;
    }
    
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

  // Save cart to SharedPreferences with user-specific key
  Future<void> _saveCart() async {
    if (_currentUserId == null) return; // Don't save if no user is logged in
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) => item.toJson()).toList();
    final cartKey = 'cart_$_currentUserId';
    await prefs.setString(cartKey, json.encode(cartData));
  }

  // Set current user and load their cart
  Future<void> setUser(String? userId, BuildContext? context) async {
    // Clear current cart when switching users
    if (_currentUserId != null && _currentUserId != userId) {
      _items.clear();
      notifyListeners();
    }
    
    _currentUserId = userId;
    
    if (userId != null && context != null) {
      await loadCart(context);
    } else {
      // Clear cart if no user is logged in
      _items.clear();
      notifyListeners();
    }
  }

  // Load cart from SharedPreferences with user-specific key
  Future<void> loadCart(BuildContext? context) async {
    if (_currentUserId == null) {
      _items.clear();
      notifyListeners();
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final cartKey = 'cart_$_currentUserId';
    final cartString = prefs.getString(cartKey);
    
    if (cartString != null) {
      final List<dynamic> cartData = json.decode(cartString);
      List<Product> products = [];
      
      // Try to get products from ProductProvider if context is available
      if (context != null) {
        try {
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          products = productProvider.products;
        } catch (e) {
          // If provider not available, use empty list
          products = [];
        }
      }
      
      // If products list is empty, try to load from ProductProvider
      if (products.isEmpty && context != null) {
        try {
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          await productProvider.loadProducts();
          products = productProvider.products;
        } catch (e) {
          // If still empty, return empty cart
          _items.clear();
          notifyListeners();
          return;
        }
      }
      
      _items = cartData
          .map((item) => CartItem.fromJson(item, products))
          .whereType<CartItem>()
          .toList();
      notifyListeners();
    } else {
      // No cart data for this user, start with empty cart
      _items.clear();
      notifyListeners();
    }
  }

  // Track sales data for dashboard (call this when order is confirmed)
  Future<void> saveSalesData(String userId) async {
    try {
      // Save to Firestore
      await _dashboardService.saveTotalSales(userId, totalAmount);
      
      // Track most added items in Firestore
      for (var item in _items) {
        await _dashboardService.saveProductCount(userId, item.product.id, item.quantity);
      }
    } catch (e) {
      print('Error saving sales data to Firestore: $e');
      // Fallback to SharedPreferences if Firestore fails
      final prefs = await SharedPreferences.getInstance();
      final currentSales = prefs.getDouble('total_sales') ?? 0.0;
      await prefs.setDouble('total_sales', currentSales + totalAmount);
      
      for (var item in _items) {
        final key = 'product_${item.product.id}_count';
        final currentCount = prefs.getInt(key) ?? 0;
        await prefs.setInt(key, currentCount + item.quantity);
      }
    }
  }

  // Get total sales from Firestore
  Future<double> getTotalSales(String userId) async {
    try {
      return await _dashboardService.getTotalSales(userId);
    } catch (e) {
      print('Error getting total sales from Firestore: $e');
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('total_sales') ?? 0.0;
    }
  }

  // Get product count from Firestore
  Future<int> getProductCount(String userId, String productId) async {
    try {
      return await _dashboardService.getProductCount(userId, productId);
    } catch (e) {
      print('Error getting product count from Firestore: $e');
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('product_${productId}_count') ?? 0;
    }
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

  // Clear cart for current user (used on logout)
  Future<void> clearUserCart() async {
    _items.clear();
    _currentUserId = null;
    notifyListeners();
  }
}





