import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../utils/responsive_helper.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  final Function(Product) onProductTap;

  const ProductListScreen({super.key, required this.onProductTap});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = dummyProducts;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = dummyProducts;
      } else {
        _filteredProducts = dummyProducts
            .where((product) =>
                product.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0a032c),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        title: Text(
          'Products',
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

       
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxWidth(context),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 16.sp),
                    prefixIcon: Icon(Icons.search, color: Colors.white70, size: 24.sp),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.white70, size: 20.sp),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 37, 53, 76),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),
              ),
              Expanded(
                child: _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64.sp,
                              color: Colors.white30,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try a different search term',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
            padding: ResponsiveHelper.getScreenPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(context),
            ),
                        itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
              return GestureDetector(
                onTap: () => widget.onProductTap(product),
                child: Card(
                  elevation: ResponsiveHelper.getCardElevation(context),
                  color: const Color.fromARGB(255, 37, 53, 76),
                  shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12.r ),
                    

                  ),
                 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100.w,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            product.image,
                            style: TextStyle(fontSize: 50.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
