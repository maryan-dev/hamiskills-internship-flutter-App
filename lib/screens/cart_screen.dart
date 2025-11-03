import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_helper.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0a032c),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 26.sp,
            ),
            onPressed: cartProvider.itemCount == 0
                ? null
                : () {
                    _showClearCartDialog(context, cartProvider);
                  },
            tooltip: 'Clear Cart',
          ),
        ],
      ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxWidth(context),
              ),
              child: cartProvider.itemCount == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 100.sp,
                            color: Colors.white30,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Add some products to get started',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: ResponsiveHelper.getScreenPadding(context),
                            itemCount: cartProvider.itemCount,
                            itemBuilder: (context, index) {
                              final cartItem = cartProvider.items[index];
                              return Card(
                                color: const Color.fromARGB(255, 37, 53, 76),
                                margin: EdgeInsets.only(bottom: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.w,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cartItem.product.image,
                                            style: TextStyle(fontSize: 35.sp),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.product.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              '\$${cartItem.product.price.toStringAsFixed(2)} each',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0XFF192441),
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  onPressed: () {
                                                    cartProvider.decreaseQuantity(
                                                      cartItem.product.id,
                                                    );
                                                  },
                                                  padding: EdgeInsets.all(4.w),
                                                  constraints: const BoxConstraints(),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 4.h,
                                                  ),
                                                  child: Text(
                                                    '${cartItem.quantity}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  onPressed: () {
                                                    cartProvider.increaseQuantity(
                                                      cartItem.product.id,
                                                    );
                                                  },
                                                  padding: EdgeInsets.all(4.w),
                                                  constraints: const BoxConstraints(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 20.sp,
                                            ),
                                            onPressed: () {
                                              _showRemoveItemDialog(
                                                context,
                                                cartProvider,
                                                cartItem.product.id,
                                                cartItem.product.name,
                                              );
                                            },
                                            tooltip: 'Remove item',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Items:',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${cartProvider.totalItems}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartProvider.subtotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CheckoutScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFF192441),
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Proceed to Checkout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart', style: TextStyle(fontSize: 20.sp)),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cart cleared successfully',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(
    BuildContext context,
    CartProvider cartProvider,
    String productId,
    String productName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item', style: TextStyle(fontSize: 20.sp)),
        content: Text(
          'Remove $productName from cart?',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeItem(productId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$productName removed from cart',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Remove',
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
