import 'package:flutter/material.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    Set<DateTime>? done,
  }) : done = done ?? {};

  final String id;
  final String name;
  final IconData icon;
  final Color color;

  /// Days on which the habit was completed (dates without time).
  final Set<DateTime> done;

  bool isDoneOn(DateTime day) => done.contains(dateOnly(day));

  /// Consecutive completed days ending today, or yesterday if today is
  /// still open.
  int streak(DateTime today) {
    var day = dateOnly(today);
    if (!done.contains(day)) day = day.subtract(const Duration(days: 1));
    var count = 0;
    while (done.contains(day)) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }
}

class HabitStore extends ChangeNotifier {
  HabitStore({List<Habit>? habits, DateTime Function()? clock})
    : _habits = habits ?? [],
      _clock = clock ?? DateTime.now;

  /// A store pre-filled with a few weeks of history, for the demo.
  factory HabitStore.demo({DateTime Function()? clock}) {
    final now = dateOnly((clock ?? DateTime.now)());
    // Completed every day for [days] days, except the [skipped] days ago.
    Set<DateTime> history(
      List<int> skipped,
      int days, {
      bool includeToday = true,
    }) => {
      for (var i = includeToday ? 0 : 1; i < days; i++)
        if (!skipped.contains(i)) now.subtract(Duration(days: i)),
    };
    return HabitStore(
      clock: clock,
      habits: [
        Habit(
          id: 'water',
          name: 'Drink 2L of water',
          icon: Icons.water_drop_outlined,
          color: const Color(0xFF42A5F5),
          done: history([5, 12, 13], 30),
        ),
        Habit(
          id: 'read',
          name: 'Read 20 pages',
          icon: Icons.menu_book_outlined,
          color: const Color(0xFFAB47BC),
          done: history([3, 9, 10, 17], 26, includeToday: false),
        ),
        Habit(
          id: 'run',
          name: 'Morning run',
          icon: Icons.directions_run,
          color: const Color(0xFFFF7043),
          done: history([1, 2, 4, 6, 8, 9, 11, 13], 21),
        ),
        Habit(
          id: 'meditate',
          name: 'Meditate 10 min',
          icon: Icons.self_improvement,
          color: const Color(0xFF26A69A),
          done: history([2, 7], 12, includeToday: false),
        ),
      ],
    );
  }

  final List<Habit> _habits;
  final DateTime Function() _clock;
  int _nextId = 1;

  DateTime get now => _clock();
  DateTime get today => dateOnly(now);
  List<Habit> get habits => List.unmodifiable(_habits);
  int get doneToday => _habits.where((h) => h.isDoneOn(today)).length;

  /// The last 7 days, oldest first.
  List<DateTime> get week => [
    for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i)),
  ];

  void toggle(Habit habit, [DateTime? day]) {
    final d = dateOnly(day ?? today);
    if (!habit.done.remove(d)) habit.done.add(d);
    notifyListeners();
  }

  void add(String name, IconData icon, Color color) {
    _habits.add(
      Habit(id: 'custom-${_nextId++}', name: name, icon: icon, color: color),
    );
    notifyListeners();
  }

  void remove(Habit habit) {
    _habits.remove(habit);
    notifyListeners();
  }

  /// Share of habits completed on [day], from 0 to 1.
  double completionOn(DateTime day) => _habits.isEmpty
      ? 0
      : _habits.where((h) => h.isDoneOn(day)).length / _habits.length;
}

class HabitScope extends InheritedNotifier<HabitStore> {
  const HabitScope({super.key, required HabitStore store, required super.child})
    : super(notifier: store);

  static HabitStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HabitScope>()!.notifier!;
}
