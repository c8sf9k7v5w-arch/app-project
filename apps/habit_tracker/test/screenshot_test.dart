import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/src/habits.dart';

import 'screenshot_utils.dart';

const _out = '../../../docs/screenshots/habits';

void main() {
  setUpAll(loadRealFonts);

  testWidgets('portfolio screenshots', skip: !screenshotsEnabled, (
    tester,
  ) async {
    await onPhone(tester, () async {
      final now = DateTime.now();
      final store = HabitStore.demo(
        clock: () => DateTime(now.year, now.month, now.day, 8, 30),
      );
      final app = find.byType(MaterialApp);

      await tester.pumpWidget(HabitApp(store: store));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_1_today.png'));

      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_2_progress.png'));

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New habit'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Go to bed by 23:00');
      await tester.tap(find.byIcon(Icons.bedtime_outlined));
      await tester.tap(find.byType(CircleAvatar).at(6));
      await tester.pumpAndSettle();
      await expectLater(app, matchesGoldenFile('${_out}_3_new_habit.png'));
    });
  });
}
