import 'package:flutter/material.dart';

import '../cart.dart';
import '../catalog.dart';
import '../widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final items = cart.items.entries.toList();

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your cart')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: scheme.outline,
              ),
              const SizedBox(height: 12),
              Text('Your cart is empty', style: text.titleMedium),
            ],
          ),
        ),
      );
    }

    final missing = Cart.freeShippingFrom - cart.subtotal;
    return Scaffold(
      appBar: AppBar(title: Text('Your cart (${cart.count})')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missing > 0
                      ? 'Add ${money(missing)} more for free shipping'
                      : 'You unlocked free shipping!',
                  style: text.labelLarge,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (cart.subtotal / Cart.freeShippingFrom).clamp(0, 1),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final e in items) ...[
            _CartLine(product: e.key, quantity: e.value),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          _SummaryRow('Subtotal', money(cart.subtotal)),
          _SummaryRow(
            'Shipping',
            cart.shipping == 0 ? 'Free' : money(cart.shipping),
          ),
          const Divider(height: 24),
          _SummaryRow('Total', money(cart.total), bold: true),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            onPressed: () {
              final total = cart.total;
              cart.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => _OrderPlacedScreen(total: total),
                ),
              );
            },
            child: Text('Checkout · ${money(cart.total)}'),
          ),
        ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.read(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: ProductImage(product: product, iconSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: text.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  money(product.price * quantity),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          QuantityStepper(
            quantity: quantity,
            onMinus: () => cart.decrement(product),
            onPlus: () => cart.add(product),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final style = bold
        ? text.titleLarge?.copyWith(fontWeight: FontWeight.w700)
        : text.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _OrderPlacedScreen extends StatelessWidget {
  const _OrderPlacedScreen({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.check, size: 56, color: scheme.primary),
              ),
              const SizedBox(height: 24),
              Text('Order placed!', style: text.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'We charged ${money(total)} and will email you '
                'the tracking number as soon as it ships.',
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
