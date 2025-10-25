import 'package:flutter/material.dart';
import '../model/product_model.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cartItems;
  final Function(int) onRemove;
  final double totalPrice;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0a032c),
      appBar: AppBar(
      backgroundColor: Color(0XFF0a032c),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green.shade50,
                          child: Text(
                            product.image,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                        subtitle: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => onRemove(index),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}



