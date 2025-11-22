import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'user_profile_screen.dart';
import '../l10n/app_localizations.dart';
import '../model/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: product,
        ),
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localization = AppLocalizations.of(context);
    final List<Widget> _screens = [
      const HomeScreen(),
      ProductListScreen(onProductTap: _navigateToProductDetails),
      const CartScreen(),
      const DashboardScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0XFF0a032c),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0a032c),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, color: Colors.white, size: 28.sp),
            color: const Color.fromARGB(255, 37, 53, 76),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white70, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      authProvider.user?.displayName?.isNotEmpty == true
                          ? authProvider.user!.displayName!
                          : authProvider.user?.email?.split('@').first ?? localization.profile,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 245, 245, 245),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 37, 45, 59),
        iconSize: 30.sp,
        selectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28.sp),
            label: localization.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 28.sp),
            label: localization.products,
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) => Badge(
                label: Text(
                  '${cart.totalItems}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                isLabelVisible: cart.totalItems > 0,
                child: Icon(Icons.shopping_cart, size: 28.sp),
              ),
            ),
            label: localization.cart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 28.sp),
            label: localization.dashboard,
          ),
        ],
      ),
    );
  }
}
