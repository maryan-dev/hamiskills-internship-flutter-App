import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Clear Firestore cache (if needed)
  Future<void> clearCache() async {
    try {
      // Note: clearPersistence() requires disabling network first
      // For now, we'll just force server fetch which is already done
      print('Cache will be bypassed by using Source.server');
    } catch (e) {
      print('Error with cache: $e');
    }
  }

  // Fetch all products from Firestore
  Future<List<Product>> getProducts() async {
    try {
      print('Fetching products from Firestore...');
      
      // Force fetch from server to avoid stale cache with duplicates
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .get(const GetOptions(source: Source.server));

      print('Received ${snapshot.docs.length} products from Firestore');

      if (snapshot.docs.isEmpty) {
        print('No products found in Firestore collection');
        return [];
      }

      // Remove duplicates based on product ID
      final uniqueProducts = <String, Product>{};
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final productId = data['id']?.toString() ?? doc.id;
          
          // Skip if we already have this product ID
          if (uniqueProducts.containsKey(productId)) {
            print('Duplicate product ID found: $productId, skipping...');
            continue;
          }
          
          final price = _parsePrice(data['price']);
          if (price <= 0) {
            print('Warning: Product ${data['name']} (ID: $productId) has invalid price: ${data['price']} (type: ${data['price'].runtimeType})');
        
            continue;
          }
          
          final product = Product(
            id: productId,
            name: data['name']?.toString() ?? '',
            price: price,
            image: data['image']?.toString() ?? '🥕',
            description: data['description']?.toString() ?? '',
          );
          
          print('Added product: ${product.name} (ID: $productId, Price: \$${product.price})');
          uniqueProducts[productId] = product;
        } catch (e) {
          print('Error parsing product document ${doc.id}: $e');
        }
      }

      final products = uniqueProducts.values.toList();
      print('Successfully parsed ${products.length} unique products from ${snapshot.docs.length} documents');

      // Sort products by id (numerically)
      products.sort((a, b) {
        final idA = int.tryParse(a.id) ?? 0;
        final idB = int.tryParse(b.id) ?? 0;
        return idA.compareTo(idB);
      });

      return products;
    } on FirebaseException catch (e) {
      print('Firebase error fetching products: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied') {
        throw Exception('Permission denied. Please check Firestore security rules.');
      } else if (e.code == 'unavailable') {
        throw Exception('Firestore is unavailable. Please check your internet connection.');
      }
      throw Exception('Firebase error: ${e.message}');
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }


  Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      // Remove duplicates based on product ID
      final uniqueProducts = <String, Product>{};
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final productId = data['id']?.toString() ?? doc.id;
          
          // Skip if we already have this product ID
          if (uniqueProducts.containsKey(productId)) {
            continue;
          }
          
          final price = _parsePrice(data['price']);
          // Skip products with invalid prices
          if (price <= 0) {
            continue;
          }
          
          final product = Product(
            id: productId,
            name: data['name']?.toString() ?? '',
            price: price,
            image: data['image']?.toString() ?? '🥕',
            description: data['description']?.toString() ?? '',
          );
          
          uniqueProducts[productId] = product;
        } catch (e) {
          print('Error parsing product document ${doc.id}: $e');
        }
      }

      final products = uniqueProducts.values.toList();

      // Sort products by id (numerically)
      products.sort((a, b) {
        final idA = int.tryParse(a.id) ?? 0;
        final idB = int.tryParse(b.id) ?? 0;
        return idA.compareTo(idB);
      });

      return products;
    });
  }

  // Helper method to parse price (handles both string and double)
  double _parsePrice(dynamic price) {
    if (price is double) {
      return price;
    } else if (price is int) {
      return price.toDouble();
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }
}

