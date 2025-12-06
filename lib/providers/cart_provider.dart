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

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _saveCart();
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      _saveCart();
    }
  }

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

  Future<void> _saveCart() async {
    if (_currentUserId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) => item.toJson()).toList();
    final cartKey = 'cart_$_currentUserId';
    await prefs.setString(cartKey, json.encode(cartData));
  }

  Future<void> setUser(String? userId, BuildContext? context) async {
    if (_currentUserId != null && _currentUserId != userId) {
      _items.clear();
      notifyListeners();
    }
    
    _currentUserId = userId;
    
    if (userId != null && context != null) {
      await loadCart(context);
    } else {
      _items.clear();
      notifyListeners();
    }
  }

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
      
      if (context != null) {
        try {
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          products = productProvider.products;
        } catch (e) {
          products = [];
        }
      }
      
      if (products.isEmpty && context != null) {
        try {
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          await productProvider.loadProducts();
          products = productProvider.products;
        } catch (e) {
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
      _items.clear();
      notifyListeners();
    }
  }

  Future<void> saveSalesData(String userId) async {
    try {
      await _dashboardService.saveTotalSales(userId, totalAmount);
      
      for (var item in _items) {
        await _dashboardService.saveProductCount(userId, item.product.id, item.quantity);
      }
    } catch (e) {
      print('Error saving sales data to Firestore: $e');
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

  Future<double> getTotalSales(String userId) async {
    try {
      return await _dashboardService.getTotalSales(userId);
    } catch (e) {
      print('Error getting total sales from Firestore: $e');
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('total_sales') ?? 0.0;
    }
  }

  Future<int> getProductCount(String userId, String productId) async {
    try {
      return await _dashboardService.getProductCount(userId, productId);
    } catch (e) {
      print('Error getting product count from Firestore: $e');
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('product_${productId}_count') ?? 0;
    }
  }

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

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  Future<void> clearUserCart() async {
    _items.clear();
    _currentUserId = null;
    notifyListeners();
  }
}





