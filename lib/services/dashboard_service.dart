import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTotalSales(String userId, double amount) async {
    try {
      final dashboardRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('sales');

      await dashboardRef.set({
        'totalSales': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving total sales: $e');
      rethrow;
    }
  }

  Future<double> getTotalSales(String userId) async {
    try {
      final dashboardRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('sales');

      final doc = await dashboardRef.get();
      if (doc.exists) {
        final data = doc.data();
        return (data?['totalSales'] as num?)?.toDouble() ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Error getting total sales: $e');
      return 0.0;
    }
  }

  Future<void> saveProductCount(String userId, String productId, int quantity) async {
    try {
      final productRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('products')
          .collection('counts')
          .doc(productId);

      await productRef.set({
        'count': FieldValue.increment(quantity),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving product count: $e');
      rethrow;
    }
  }

  Future<int> getProductCount(String userId, String productId) async {
    try {
      final productRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('products')
          .collection('counts')
          .doc(productId);

      final doc = await productRef.get();
      if (doc.exists) {
        final data = doc.data();
        return (data?['count'] as int?) ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting product count: $e');
      return 0;
    }
  }

  Future<Map<String, int>> getAllProductCounts(String userId) async {
    try {
      final countsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dashboard')
          .doc('products')
          .collection('counts');

      final snapshot = await countsRef.get();
      final Map<String, int> counts = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        counts[doc.id] = (data['count'] as int?) ?? 0;
      }

      return counts;
    } catch (e) {
      print('Error getting all product counts: $e');
      return {};
    }
  }
}

