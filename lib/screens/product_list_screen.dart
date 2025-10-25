import 'package:flutter/material.dart';
import '../model/product_model.dart';

class ProductListScreen extends StatelessWidget {
  final Function(Product) onProductTap;

  const ProductListScreen({super.key, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFF0a032c),

      appBar: AppBar(
        backgroundColor: Color(0XFF0a032c),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return GestureDetector(
            onTap: () => onProductTap(product),
            child: Card(
              elevation: 4,
              color: Color.fromARGB(255, 37, 53, 76),
              
              shape: RoundedRectangleBorder(
                
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(53),
                    topLeft: Radius.circular(54),
                  ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        product.image,
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


