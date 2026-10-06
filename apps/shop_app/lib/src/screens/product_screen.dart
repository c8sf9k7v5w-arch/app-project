import 'package:flutter/material.dart';

import '../cart.dart';
import '../catalog.dart';
import '../widgets.dart';
import 'catalog_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final cart = CartScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Favorite',
            onPressed: () => cart.toggleFavorite(p),
            icon: Icon(
              cart.isFavorite(p) ? Icons.favorite : Icons.favorite_border,
              color: Colors.red.shade400,
            ),
          ),
          const CartButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          SizedBox(height: 300, child: ProductImage(product: p, iconSize: 140)),
          const SizedBox(height: 20),
          Text(
            p.category.toUpperCase(),
            style: text.labelMedium?.copyWith(
              color: scheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.name,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Rating(value: p.rating),
              const SizedBox(width: 12),
              Icon(
                Icons.local_shipping_outlined,
                size: 16,
                color: scheme.outline,
              ),
              const SizedBox(width: 4),
              Text('Ships in 24h', style: text.labelMedium),
            ],
          ),
          const SizedBox(height: 16),
          Text(p.description, style: text.bodyLarge),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Quantity', style: text.titleMedium),
              const Spacer(),
              QuantityStepper(
                quantity: _quantity,
                onMinus: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                onPlus: () => setState(() => _quantity++),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            onPressed: () {
              cart.add(p, _quantity);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Add to cart · ${money(p.price * _quantity)}'),
          ),
        ),
      ),
    );
  }
}
