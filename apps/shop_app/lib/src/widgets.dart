import 'package:flutter/material.dart';

import 'catalog.dart';

/// Products use a tinted illustration tile instead of photos, so the demo
/// works offline and has no image licensing issues.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product, this.iconSize = 48});

  final Product product;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final tint = HSLColor.fromColor(product.tint);
    return Hero(
      tag: product.id,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tint.withLightness((tint.lightness + 0.12).clamp(0, 1)).toColor(),
              product.tint,
            ],
          ),
        ),
        child: Icon(
          product.icon,
          size: iconSize,
          color: tint.withLightness(0.25).toColor(),
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  const Rating({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade600),
        const SizedBox(width: 2),
        Text(
          value.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Less',
            visualDensity: VisualDensity.compact,
            onPressed: onMinus,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: 'More',
            visualDensity: VisualDensity.compact,
            onPressed: onPlus,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
