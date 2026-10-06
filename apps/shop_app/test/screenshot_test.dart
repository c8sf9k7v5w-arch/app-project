import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/src/cart.dart';
import 'package:shop_app/src/catalog.dart';

import 'screenshot_utils.dart';

const _out = '../../../docs/screenshots/shop';

void main() {
  setUpAll(loadRealFonts);

  testWidgets('portfolio screenshots', skip: !screenshotsEnabled, (
    tester,
  ) async {
    await onPhone(tester, () async {
      final cart = Cart()
        ..add(products[0], 2)
        ..toggleFavorite(products[3]);
      final app = find.byType(MaterialApp);

      await tester.pumpWidget(ShopApp(cart: cart));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_1_catalog.png'));

      await tester.tap(find.text('Olive Wood Board'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_2_product.png'));

      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Cart'));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_3_cart.png'));

      await tester.tap(find.textContaining('Checkout'));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_4_order.png'));
    });
  });
}
