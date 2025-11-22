import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../services/firebase_service.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts({bool forceRefresh = false}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('ProductProvider: Loading products... (forceRefresh: $forceRefresh)');
      
      // Clear cache if force refresh
      if (forceRefresh) {
        await _firebaseService.clearCache();
      }
      
      final fetchedProducts = await _firebaseService.getProducts();
      print('ProductProvider: Loaded ${fetchedProducts.length} products');
      
      // Remove any duplicates that might have slipped through
      final uniqueProducts = <String, Product>{};
      for (var product in fetchedProducts) {
        if (!uniqueProducts.containsKey(product.id)) {
          uniqueProducts[product.id] = product;
        }
      }
      
      _products = uniqueProducts.values.toList();
      _isLoading = false;
      
      print('ProductProvider: Final product count after deduplication: ${_products.length}');
      
      if (_products.isEmpty) {
        _errorMessage = 'No products available. Please add products in Firestore.';
      }
      
      notifyListeners();
    } catch (e) {
      print('ProductProvider: Error loading products - $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _products = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

