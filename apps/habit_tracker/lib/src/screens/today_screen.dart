import 'package:flutter/material.dart';

import '../format.dart';
import '../habits.dart';
import 'new_habit_sheet.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HabitScope.of(context);
    final habits = store.habits;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => NewHabitSheet(store: store),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New habit'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
          children: [
            Text(
              longDate(store.today),
              style: text.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              greeting(store.now),
              style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _ProgressCard(done: store.doneToday, total: habits.length),
            const SizedBox(height: 20),
            if (habits.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Add your first habit to start.')),
              ),
            for (final h in habits) ...[
              _HabitCard(habit: h),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final value = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: scheme.onPrimary,
                  backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
                ),
                Center(
                  child: Text(
                    '${(value * 100).round()}%',
                    style: text.titleMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done == total && total > 0
                      ? 'All done for today!'
                      : '$done of $total habits done',
                  style: text.titleLarge?.copyWith(color: scheme.onPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Small steps every day add up.',
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final store = HabitScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final doneToday = habit.isDoneOn(store.today);
    final streak = habit.streak(store.today);

    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => store.toggle(habit),
        onLongPress: () => _confirmDelete(context, store),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: habit.color.withValues(alpha: 0.15),
                child: Icon(habit.icon, color: habit.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.name, style: text.titleMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: streak > 0
                              ? Colors.deepOrange
                              : scheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          streak == 1 ? '1 day' : '$streak days',
                          style: text.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final d in store.week)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _DayDot(
                              label: weekdayLetter(d),
                              done: habit.isDoneOn(d),
                              color: habit.color,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: doneToday ? habit.color : Colors.transparent,
                  border: Border.all(color: habit.color, width: 2.5),
                ),
                child: Icon(
                  Icons.check,
                  color: doneToday ? Colors.white : habit.color,
                  semanticLabel: doneToday ? 'Done' : 'Not done',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, HabitStore store) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${habit.name}"?'),
        content: const Text('Its history will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) store.remove(habit);
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.label, required this.done, required this.color});

  final String label;
  final bool done;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? color.withValues(alpha: 0.85)
            : color.withValues(alpha: 0.1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: done ? Colors.white : color,
        ),
      ),
    );
  }
}
