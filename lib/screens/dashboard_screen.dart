import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../model/product_model.dart';
import '../utils/responsive_helper.dart';
import 'product_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _totalSales = 0.0;
  List<Map<String, dynamic>> _mostAddedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    final sales = await cartProvider.getTotalSales();
    
    final List<Map<String, dynamic>> productCounts = [];
    for (var product in dummyProducts) {
      final count = await cartProvider.getProductCount(product.id);
      if (count > 0) {
        productCounts.add({
          'product': product,
          'count': count,
        });
      }
    }
    
    productCounts.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    
    setState(() {
      _totalSales = sales;
      _mostAddedItems = productCounts.take(5).toList(); 
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0a032c),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxWidth(context),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: ResponsiveHelper.getScreenPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 37, 53, 76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.green,
                                    size: 30.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Total Sales',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                '\$${_totalSales.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        'Most Added Items',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _mostAddedItems.isEmpty
                          ? Card(
                              color: const Color.fromARGB(255, 37, 53, 76),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(40.w),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 64.sp,
                                      color: Colors.white30,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No items added yet',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Start adding products to see statistics',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _mostAddedItems.length,
                              itemBuilder: (context, index) {
                                final item = _mostAddedItems[index];
                                final product = item['product'] as Product;
                                final count = item['count'] as int;

                                return Card(
                                  color: const Color.fromARGB(255, 37, 53, 76),
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.w,
                                            decoration: BoxDecoration(
                                              color: index == 0
                                                  ? Colors.amber
                                                  : index == 1
                                                      ? Colors.grey.shade400
                                                      : index == 2
                                                          ? Colors.brown.shade400
                                                          : Colors.blue.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Container(
                                            width: 60.w,
                                            height: 60.w,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                product.image,
                                                style: TextStyle(fontSize: 30.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  'Added $count times',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              '$count',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      SizedBox(height: 24.h),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loadDashboardData,
                          icon: Icon(Icons.refresh, color: Colors.white, size: 20.sp),
                          label: Text(
                            'Refresh Data',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF192441),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

