class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });
}

// Dummy data for products
final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Fresh Apples(2kg)',
    price: 2.99,
    image: '🍎',
    description: 'Crisp and sweet red apples, perfect for a healthy snack.',
  ),
  Product(
    id: '2',
    name: 'Bananas (Bunch)',
    price: 1.89,
    image: '🍌',
    description: 'Sweet and ripe bananas, great for breakfast or a quick snack.',
  ),
  Product(
    id: '3',
    name: 'Carrots (1kg)',
    price: 1.49,
    image: '🥕',
    description: 'Fresh crunchy carrots, packed with vitamins and nutrients.',
  ),
  Product(
    id: '4',
    name: 'Broccoli',
    price: 2.20,
    image: '🥦',
    description: 'Fresh green broccoli, perfect for stir-fries and salads.',
  ),
  Product(
    id: '5',
    name: 'Tomatoes (500g)',
    price: 2.50,
    image: '🍅',
    description: 'Juicy red tomatoes, ideal for salads and cooking.',
  ),
  Product(
    id: '6',
    name: 'Spinach Bag',
    price: 3.10,
    image: '🥬',
    description: 'Fresh organic spinach, loaded with iron and vitamins.',
  ),
  Product(
    id: '7',
    name: 'Oranges (1kg)',
    price: 2.75,
    image: '🍊',
    description: 'Sweet and juicy oranges, rich in vitamin C.',
  ),
  Product(
    id: '8',
    name: 'Strawberries (250g)',
    price: 4.50,
    image: '🍓',
    description: 'Fresh sweet strawberries, perfect for desserts.',
  ),
  Product(
    id: '9',
    name: 'Grapes (500g)',
    price: 3.99,
    image: '🍇',
    description: 'Sweet and juicy grapes, perfect for snacking.',
  ),
  Product(
    id: '10',
    name: 'Watermelon',
    price: 5.99,
    image: '🍉',
    description: 'Fresh and refreshing watermelon, great for summer.',
  ),
  Product(
    id: '11',
    name: 'Potatoes (1kg)',
    price: 1.99,
    image: '🥔',
    description: 'Fresh potatoes, versatile for cooking.',
  ),
  Product(
    id: '12',
    name: 'Onions (500g)',
    price: 1.29,
    image: '🧅',
    description: 'Fresh onions, essential for many recipes.',
  ),
  Product(
    id: '13',
    name: 'Peppers',
    price: 2.99,
    image: '🫑',
    description: 'Fresh bell peppers in assorted colors.',
  ),
  Product(
    id: '14',
    name: 'Cucumber',
    price: 1.49,
    image: '🥒',
    description: 'Fresh crunchy cucumber, perfect for salads.',
  ),
  Product(
    id: '15',
    name: 'Lettuce',
    price: 2.25,
    image: '🥬',
    description: 'Fresh crisp lettuce, great for salads and sandwiches.',
  ),
];


