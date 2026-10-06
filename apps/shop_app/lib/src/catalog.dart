import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    required this.icon,
    required this.tint,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String description;
  final IconData icon;
  final Color tint;
}

const categories = ['All', 'Coffee', 'Kitchen', 'Home', 'Gifts'];

const products = <Product>[
  Product(
    id: 'p1',
    name: 'Espresso Blend 500g',
    category: 'Coffee',
    price: 14.90,
    rating: 4.8,
    description:
        'Dark roast with notes of cocoa and toasted hazelnut. '
        'Roasted weekly in small batches in Turin.',
    icon: Icons.coffee,
    tint: Color(0xFFD7B899),
  ),
  Product(
    id: 'p2',
    name: 'Moka Pot 6 cups',
    category: 'Kitchen',
    price: 32.00,
    rating: 4.7,
    description:
        'Classic aluminium stovetop coffee maker. '
        'Makes six cups of rich, full-bodied coffee.',
    icon: Icons.coffee_maker_outlined,
    tint: Color(0xFFB0BEC5),
  ),
  Product(
    id: 'p3',
    name: 'Ceramic Mug Set',
    category: 'Kitchen',
    price: 24.50,
    rating: 4.6,
    description: 'Set of four hand-glazed mugs, 300 ml, dishwasher safe.',
    icon: Icons.local_cafe_outlined,
    tint: Color(0xFFA5D6A7),
  ),
  Product(
    id: 'p4',
    name: 'Olive Wood Board',
    category: 'Home',
    price: 39.00,
    rating: 4.9,
    description:
        'Cutting and serving board carved from a single piece of olive wood.',
    icon: Icons.table_restaurant_outlined,
    tint: Color(0xFFFFCC80),
  ),
  Product(
    id: 'p5',
    name: 'Single Origin Ethiopia',
    category: 'Coffee',
    price: 17.50,
    rating: 4.9,
    description:
        'Light roast with bright citrus and jasmine aromas. '
        'Perfect for filter brewing.',
    icon: Icons.eco_outlined,
    tint: Color(0xFFFFAB91),
  ),
  Product(
    id: 'p6',
    name: 'Scented Candle',
    category: 'Home',
    price: 19.00,
    rating: 4.5,
    description: 'Soy wax candle with fig and cedar scent, 40 hours burn time.',
    icon: Icons.local_fire_department_outlined,
    tint: Color(0xFFCE93D8),
  ),
  Product(
    id: 'p7',
    name: 'Gift Box Deluxe',
    category: 'Gifts',
    price: 59.00,
    rating: 4.8,
    description:
        'Two coffees, a moka pot and a mug, wrapped and ready to give.',
    icon: Icons.card_giftcard,
    tint: Color(0xFFEF9A9A),
  ),
  Product(
    id: 'p8',
    name: 'Milk Frother',
    category: 'Kitchen',
    price: 27.90,
    rating: 4.4,
    description: 'Rechargeable handheld frother for cappuccino at home.',
    icon: Icons.blender_outlined,
    tint: Color(0xFF90CAF9),
  ),
];

String money(double value) => '€${value.toStringAsFixed(2)}';
