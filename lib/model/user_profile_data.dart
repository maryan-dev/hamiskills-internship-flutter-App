class UserProfileData {
  final String userId;
  final String fullName;
  final String email;
  final String status;
  final int totalOrders;
  final int totalFavorites;
  final int totalReviews;

  const UserProfileData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.status,
    required this.totalOrders,
    required this.totalFavorites,
    required this.totalReviews,
  });

  UserProfileData copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? status,
    int? totalOrders,
    int? totalFavorites,
    int? totalReviews,
  }) {
    return UserProfileData(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      status: status ?? this.status,
      totalOrders: totalOrders ?? this.totalOrders,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}



