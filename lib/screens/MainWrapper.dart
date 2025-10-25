import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import '../model/product_model.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final List<Product> _cartItems = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double _getTotalPrice() {
    return _cartItems.fold(0, (sum, product) => sum + product.price);
  }

  void _navigateToProductDetails(Product product) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: product,
          onAddToCart: _addToCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomeScreen(),
      ProductListScreen(onProductTap: _navigateToProductDetails),
      CartScreen(
        cartItems: _cartItems,
        onRemove: _removeFromCart,
        totalPrice: _getTotalPrice(),
      ),
    ];

    return Scaffold(
  backgroundColor: Color(0XFF0a032c),
  
  body: _screens[_currentIndex],
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: _onTabTapped,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color.fromARGB(255, 245, 245, 245),
    unselectedItemColor: Colors.white,

backgroundColor:                Color.fromARGB(255, 39, 48, 59),

    iconSize: 30, 

    selectedLabelStyle: TextStyle(
      fontSize: 16, 
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14, 
    ),

    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'Products',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
    ],
  ),
);
  }
}