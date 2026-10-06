import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/src/habits.dart';

void main() {
  final today = DateTime(2026, 10, 6);

  test('streak counts back from today, or from yesterday if today is open', () {
    final h = Habit(
      id: 'h',
      name: 'Test',
      icon: Icons.check,
      color: Colors.blue,
      done: {
        DateTime(2026, 10, 5),
        DateTime(2026, 10, 4),
        DateTime(2026, 10, 2),
      },
    );
    expect(h.streak(today), 2);
    h.done.add(today);
    expect(h.streak(today), 3);
  });

  test('completion rate per day', () {
    final store = HabitStore(clock: () => today);
    store.add('A', Icons.check, Colors.red);
    store.add('B', Icons.check, Colors.red);
    store.toggle(store.habits.first);
    expect(store.doneToday, 1);
    expect(store.completionOn(today), 0.5);
  });

  testWidgets('tapping a habit marks it done and new habits can be added', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    final store = HabitStore(clock: () => today);
    await tester.pumpWidget(HabitApp(store: store));
    expect(find.text('Add your first habit to start.'), findsOneWidget);

    await tester.tap(find.text('New habit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Stretch');
    await tester.pump();
    await tester.tap(find.text('Add habit'));
    await tester.pumpAndSettle();
    expect(find.text('Stretch'), findsOneWidget);

    await tester.tap(find.text('Stretch'));
    await tester.pumpAndSettle();
    expect(store.doneToday, 1);
    expect(find.text('All done for today!'), findsOneWidget);
  });
}
