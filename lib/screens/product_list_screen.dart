import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../providers/product_provider.dart';
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
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      _filterProducts(productProvider.products);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilteredProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _filterProducts(productProvider.products);
  }

  void _filterProducts(List<Product> products) {
    // Remove duplicates based on product ID
    final uniqueProducts = <String, Product>{};
    for (var product in products) {
      if (!uniqueProducts.containsKey(product.id)) {
        uniqueProducts[product.id] = product;
      }
    }
    final deduplicatedProducts = uniqueProducts.values.toList();
    
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = deduplicatedProducts;
      } else {
        _filteredProducts = deduplicatedProducts
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
                  onChanged: (value) {
                    final productProvider = Provider.of<ProductProvider>(context, listen: false);
                    _filterProducts(productProvider.products);
                  },
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
                              final productProvider = Provider.of<ProductProvider>(context, listen: false);
                              _filterProducts(productProvider.products);
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
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    // Remove duplicates from products based on ID
                    final uniqueProducts = <String, Product>{};
                    for (var product in productProvider.products) {
                      if (!uniqueProducts.containsKey(product.id)) {
                        uniqueProducts[product.id] = product;
                      }
                    }
                    final deduplicatedProducts = uniqueProducts.values.toList();
                    
                    // Filter products based on search query
                    final query = _searchController.text.toLowerCase();
                    final filteredProducts = query.isEmpty
                        ? deduplicatedProducts
                        : deduplicatedProducts
                            .where((product) =>
                                product.name.toLowerCase().contains(query))
                            .toList();
                    
                    // Update state if needed
                    if (filteredProducts.length != _filteredProducts.length ||
                        !filteredProducts.every((p) => _filteredProducts.any((fp) => fp.id == p.id))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _filteredProducts = filteredProducts;
                          });
                        }
                      });
                    }
                    
                    if (productProvider.isLoading && filteredProducts.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    }
                    if (productProvider.errorMessage != null && filteredProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              productProvider.errorMessage!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => productProvider.loadProducts(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (filteredProducts.isEmpty) {
                      return Center(
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
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        await productProvider.loadProducts(forceRefresh: true);
                        _updateFilteredProducts();
                      },
                      color: Colors.green,
                      child: GridView.builder(
            padding: ResponsiveHelper.getScreenPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(context),
            ),
                        itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
              )
                    );
            },
                      ),
                    ),
            ]
                      ),
                      
        ),
              ),
            
          
        
      
    );
  }
}
