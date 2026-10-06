import 'package:flutter/widgets.dart';

import 'catalog.dart';

class Cart extends ChangeNotifier {
  static const freeShippingFrom = 49.0;
  static const shippingFee = 4.90;

  final Map<Product, int> _items = {};
  final Set<Product> _favorites = {};

  Map<Product, int> get items => Map.unmodifiable(_items);
  int get count => _items.values.fold(0, (a, b) => a + b);
  double get subtotal =>
      _items.entries.fold(0, (sum, e) => sum + e.key.price * e.value);
  double get shipping =>
      _items.isEmpty || subtotal >= freeShippingFrom ? 0 : shippingFee;
  double get total => subtotal + shipping;

  bool isFavorite(Product p) => _favorites.contains(p);

  void toggleFavorite(Product p) {
    if (!_favorites.remove(p)) _favorites.add(p);
    notifyListeners();
  }

  void add(Product p, [int quantity = 1]) {
    _items.update(p, (q) => q + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  void decrement(Product p) {
    final q = _items[p];
    if (q == null) return;
    if (q <= 1) {
      _items.remove(p);
    } else {
      _items[p] = q - 1;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartScope extends InheritedNotifier<Cart> {
  const CartScope({super.key, required Cart cart, required super.child})
    : super(notifier: cart);

  static Cart of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartScope>()!.notifier!;

  /// Reads the cart without rebuilding when it changes (for callbacks).
  static Cart read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<CartScope>()!.notifier!;
}
