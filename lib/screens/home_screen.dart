import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../model/product_model.dart';
import '../utils/responsive_helper.dart';
import '../l10n/app_localizations.dart';
import 'cart_screen.dart';
import 'product_list_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0XFF0a032c),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        elevation: 0,
        title: Center(
          child: Text(
            localization.appTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0XFF0a032c),
                    const Color(0XFF1a1542),
                    const Color(0XFF2a2560),
                  ],
                ),
              ),
          child: Column(
            children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.store,
                      size: 60.sp,
                      color: Colors.green.shade300,
                    ),
                  ),
                  SizedBox(height: 24.h),
              Text(
                localization.welcome,
                style: TextStyle(
                      fontSize: 36.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localization.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localization.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            //   child: Consumer<CartProvider>(
            //     builder: (context, cart, child) => Row(
            //       children: [
            //         Expanded(
            //           child: _buildStatCard(
            //             context,
            //             icon: Icons.shopping_bag,
            //             title: 'Products',
            //             value: '${dummyProducts.length}',
            //             color: Colors.blue,
            //           ),
            //         ),
            //         SizedBox(width: 12.w),
            //         Expanded(
            //           child: _buildStatCard(
            //             context,
            //             icon: Icons.shopping_cart,
            //             title: 'In Cart',
            //             value: '${cart.totalItems}',
            //             color: Colors.green,
            //           ),
            //         ),
            //         SizedBox(width: 12.w),
            //         Expanded(
            //           child: _buildStatCard(
            //             context,
            //             icon: Icons.attach_money,
            //             title: 'Total',
            //             value: '\$${cart.totalAmount.toStringAsFixed(0)}',
            //             color: Colors.orange,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Quick Actions',
            //         style: TextStyle(
            //           fontSize: 22.sp,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       SizedBox(height: 16.h),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: _buildQuickActionCard(
            //               context,
            //               icon: Icons.list_alt,
            //               title: 'Browse Products',
            //               subtitle: 'View all items',
            //               color: Colors.blue,
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => ProductListScreen(
            //                       onProductTap: (product) => _navigateToProductDetails(context, product),
            //                     ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //           SizedBox(width: 12.w),
            //           Expanded(
            //             child: _buildQuickActionCard(
            //               context,
            //               icon: Icons.shopping_cart_outlined,
            //               title: 'My Cart',
            //               subtitle: 'View cart',
            //               color: Colors.green,
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => const CartScreen(),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 16.h),
            //     ],
            //   ),
            // ),

              Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                  localization.featuredProducts,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(
                            onProductTap: (product) => _navigateToProductDetails(context, product),
                          ),
                        ),
                      );
                    },
                    child: Text(
                    localization.seeAll,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 220.h,
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.green,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            localization.loadingProducts,
                            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  }
                  if (productProvider.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48.sp,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              productProvider.errorMessage!,
                              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () => productProvider.loadProducts(),
                              icon: Icon(Icons.refresh, size: 20.sp),
                            label: Text(localization.retry),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (productProvider.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.white30,
                            size: 48.sp,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            localization.noProducts,
                            style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            localization.addProducts,
                            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton.icon(
                            onPressed: () => productProvider.loadProducts(),
                            icon: Icon(Icons.refresh, size: 20.sp),
                            label: Text(localization.refresh),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Remove duplicates
                  final uniqueProducts = <String, Product>{};
                  for (var product in productProvider.products) {
                    if (!uniqueProducts.containsKey(product.id) && product.price > 0) {
                      uniqueProducts[product.id] = product;
                    }
                  }
                  final deduplicatedProducts = uniqueProducts.values.toList();
                  final featuredProducts = deduplicatedProducts.take(6).toList();
                  
                  return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                      final product = featuredProducts[index];
                  return Container(
                    width: 160.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: _buildFeaturedProductCard(context, product),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade900,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.specialOffer,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            localization.specialOfferDescription,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 53, 76),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 37, 53, 76),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white60,
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildFeaturedProductCard(BuildContext context, Product product) {
    return InkWell(
      onTap: () {
        _navigateToProductDetails(context, product);
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 37, 53, 76),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.green.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
              ),
              child: Center(
                child: Text(
                  product.image,
                  style: TextStyle(fontSize: 50.sp),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



