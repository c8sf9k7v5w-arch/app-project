import 'package:booking_app/main.dart';
import 'package:booking_app/src/data.dart';
import 'package:booking_app/src/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'screenshot_utils.dart';

const _out = '../../../docs/screenshots/booking';

void main() {
  setUpAll(loadRealFonts);

  testWidgets('portfolio screenshots', skip: !screenshotsEnabled, (
    tester,
  ) async {
    await onPhone(tester, () async {
      final store = BookingStore();
      final now = DateTime.now();
      final day = DateTime(now.year, now.month, now.day + 2);
      for (final (service, stylist, hour) in [
        (services[0], stylists[0], 10),
        (services[4], stylists[2], 15),
      ]) {
        final slot = slotsFor(day).firstWhere(
          (s) =>
              s.hour >= hour &&
              store.isAvailable(s, stylist, minutes: service.minutes),
        );
        store.book(service, stylist, slot);
      }

      await tester.pumpWidget(BookingApp(store: store));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('${_out}_1_services.png'),
      );

      await tester.tap(find.text('Full Color'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sara'));
      await tester.tap(find.byType(InkWell).at(2));
      await tester.pumpAndSettle();
      final free = find.byWidgetPredicate(
        (w) => w is ChoiceChip && w.onSelected != null,
      );
      await tester.tap(free.at(3));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('${_out}_2_book.png'),
      );

      await tester.tap(find.text('Book now'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('${_out}_3_confirmed.png'),
      );

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My bookings'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('${_out}_4_bookings.png'),
      );
    });
  });
}
