import 'package:booking_app/main.dart';
import 'package:booking_app/src/data.dart';
import 'package:booking_app/src/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the service list', (tester) async {
    await tester.pumpWidget(BookingApp(store: BookingStore()));
    expect(find.text('Glow Studio'), findsOneWidget);
    expect(find.text('Haircut & Style'), findsOneWidget);
  });

  test('a booked slot is no longer available for that stylist', () {
    final store = BookingStore();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final stylist = stylists.first;
    final slot = slotsFor(tomorrow)
        .firstWhere((s) => store.isAvailable(s, stylist));

    store.book(services.first, stylist, slot);

    expect(store.isAvailable(slot, stylist), isFalse);
    // A 90-minute service starting 30 minutes earlier would overlap it.
    final before = slot.subtract(const Duration(minutes: 30));
    expect(store.isAvailable(before, stylist, minutes: 90), isFalse);
    expect(store.upcoming, hasLength(1));
    store.cancel(store.upcoming.first);
    expect(store.isAvailable(slot, stylist), isTrue);
  });

  testWidgets('booking flow adds a booking', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final store = BookingStore();
    await tester.pumpWidget(BookingApp(store: store));
    await tester.tap(find.text('Haircut & Style'));
    await tester.pumpAndSettle();

    // Move to the next day so every slot is in the future.
    await tester.tap(find.byType(InkWell).at(1));
    await tester.pumpAndSettle();
    final chip = find.byWidgetPredicate(
      (w) => w is ChoiceChip && w.onSelected != null,
    );
    await tester.tap(chip.first);
    await tester.pump();
    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();

    expect(find.text('You\'re booked!'), findsOneWidget);
    expect(store.upcoming, hasLength(1));
  });
}
