import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_profile_data.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfileData> fetchProfileData({
    required String userId,
    required String fallbackName,
    required String fallbackEmail,
  }) async {
    final userDoc =
        await _firestore.collection('users').doc(userId).get();
    final ordersSnapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    final favoritesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    final reviewsSnapshot = await _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .get();

    final Map<String, dynamic>? userData =
        userDoc.data() as Map<String, dynamic>?;

    String _resolveString(String fieldValue, String fallback) {
      final value =
          fieldValue.trim().isNotEmpty ? fieldValue.trim() : fallback;
      return value;
    }

    final fullName = _resolveString(
      (userData?['fullName'] as String?) ?? fallbackName,
      fallbackName,
    );
    final email = _resolveString(
      (userData?['email'] as String?) ?? fallbackEmail,
      fallbackEmail,
    );
    final status = _resolveString(
      (userData?['status'] as String?) ?? 'Active',
      'Active',
    );

    return UserProfileData(
      userId: userId,
      fullName: fullName,
      email: email,
      status: status,
      totalOrders: ordersSnapshot.docs.length,
      totalFavorites: favoritesSnapshot.docs.length,
      totalReviews: reviewsSnapshot.docs.length,
    );
  }
}

