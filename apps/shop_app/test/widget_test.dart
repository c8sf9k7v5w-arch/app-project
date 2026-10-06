import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/src/cart.dart';
import 'package:shop_app/src/catalog.dart';

void main() {
  test('cart totals and free shipping threshold', () {
    final cart = Cart();
    cart.add(products[0], 2); // 2 x 14.90
    expect(cart.count, 2);
    expect(cart.subtotal, closeTo(29.80, 0.001));
    expect(cart.shipping, Cart.shippingFee);

    cart.add(products[1]); // + 32.00
    expect(cart.shipping, 0);
    expect(cart.total, closeTo(61.80, 0.001));

    cart.decrement(products[1]);
    cart.decrement(products[0]);
    expect(cart.count, 1);
  });

  testWidgets('filters by category and adds to cart', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final cart = Cart();
    await tester.pumpWidget(ShopApp(cart: cart));

    await tester.tap(find.widgetWithText(ChoiceChip, 'Coffee'));
    await tester.pumpAndSettle();
    expect(find.text('Single Origin Ethiopia'), findsOneWidget);
    expect(find.text('Moka Pot 6 cups'), findsNothing);

    await tester.tap(find.byTooltip('Add Espresso Blend 500g'));
    await tester.pump();
    expect(cart.count, 1);
  });

  testWidgets('checkout empties the cart', (tester) async {
    final cart = Cart()..add(products[3]);
    await tester.pumpWidget(ShopApp(cart: cart));

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Order placed!'), findsOneWidget);
    expect(cart.count, 0);
  });
}
