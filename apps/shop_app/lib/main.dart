import 'package:flutter/material.dart';

import 'src/cart.dart';
import 'src/screens/catalog_screen.dart';

void main() => runApp(ShopApp(cart: Cart()));

class ShopApp extends StatelessWidget {
  const ShopApp({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cart: cart,
      child: MaterialApp(
        title: 'Bottega',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF2E6B4F),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F8F5),
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
