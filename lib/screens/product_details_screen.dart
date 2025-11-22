import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../model/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override

  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.name,
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxWidth(context),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildHeroSection(context),
                SizedBox(height: 20.h),
                _buildInfoCard(localization),
                SizedBox(height: 16.h),
                _buildDescriptionCard(localization),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => _handleAddToCart(cartProvider, localization),
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 20.sp),
            label: Text(
              localization.addToCart,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFF192441),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final bool isMobile = ResponsiveHelper.isMobile(context);
    final double cardHeight = isMobile ? 360.h : 420.h;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildProductImage(context),
          ),
          Positioned(
            top: 8,
            right: 0,
            child: _buildFavoriteBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final image = widget.product.image.trim();
    final double emojiSize = ResponsiveHelper.isMobile(context) ? 160.sp : 220.sp;

    if (_isEmoji(image) || image.isEmpty) {
      return Text(
        image.isEmpty ? '🛒' : image,
        style: TextStyle(fontSize: emojiSize),
      );
    }

    final BorderRadius imageRadius = BorderRadius.circular(24.r);

    if (_isNetworkImage(image)) {
      return ClipRRect(
        borderRadius: imageRadius,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.isMobile(context) ? 260.w : 320.w,
            maxHeight: ResponsiveHelper.isMobile(context) ? 260.w : 320.w,
          ),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                      : null,
                  color: Colors.green,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
          ),
        ),
      );
    }

    if (_isAssetImage(image)) {
      return ClipRRect(
        borderRadius: imageRadius,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          width: ResponsiveHelper.isMobile(context) ? 260.w : 320.w,
          height: ResponsiveHelper.isMobile(context) ? 260.w : 320.w,
          errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
        ),
      );
    }

    return _buildImageFallback();
  }

  Widget _buildFavoriteBadge() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.favorite_border,
        color: Colors.red.shade300,
        size: 22.sp,
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations localization) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          widget.product.price.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.green,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      localization.inStock,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '4.0 (120 reviews)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(AppLocalizations localization) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: Colors.green, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                localization.description,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? 220.w : 280.w,
      height: ResponsiveHelper.isMobile(context) ? 220.w : 280.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 56.sp,
        color: Colors.green.shade200,
      ),
    );
  }

  void _handleAddToCart(CartProvider cartProvider, AppLocalizations localization) {
    for (int i = 0; i < _quantity; i++) {
      cartProvider.addItem(widget.product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                '${widget.product.name} (x$_quantity) ${localization.addedToCartMessage}',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        action: SnackBarAction(
          label: localization.viewCart,
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  bool _isNetworkImage(String value) => value.startsWith('http');

  bool _isAssetImage(String value) => value.startsWith('assets/');

  bool _isEmoji(String value) {
    if (value.isEmpty) return true;
    final runes = value.trim().runes.toList();
    return !value.contains('/') && runes.length <= 3;
  }
}