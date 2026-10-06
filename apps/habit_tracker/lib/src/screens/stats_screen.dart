import 'package:flutter/material.dart';

import '../format.dart';
import '../habits.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HabitScope.of(context);
    final habits = store.habits;
    final text = Theme.of(context).textTheme;
    final week = store.week;
    final weekRate = week.isEmpty
        ? 0.0
        : week.map(store.completionOn).reduce((a, b) => a + b) / week.length;
    final best = habits.fold<int>(
      0,
      (m, h) => h.streak(store.today) > m ? h.streak(store.today) : m,
    );
    final checkIns = habits.fold<int>(0, (n, h) => n + h.done.length);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Progress',
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Row(
            children: [
              _StatTile(
                label: 'This week',
                value: '${(weekRate * 100).round()}%',
                icon: Icons.trending_up,
              ),
              const SizedBox(width: 12),
              _StatTile(
                label: 'Best streak',
                value: '$best d',
                icon: Icons.local_fire_department,
              ),
              const SizedBox(width: 12),
              _StatTile(
                label: 'Check-ins',
                value: '$checkIns',
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Last 7 days',
            child: SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final d in week)
                    Expanded(
                      child: _Bar(
                        value: store.completionOn(d),
                        label: weekdayShort(d),
                        highlight: d == store.today,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final h in habits) ...[
            _Section(
              title: h.name,
              trailing: Icon(h.icon, color: h.color),
              child: _Heatmap(habit: h, today: store.today),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.primary, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.label,
    required this.highlight,
  });

  final double value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${(value * 100).round()}%', style: text.labelSmall),
        const SizedBox(height: 4),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value.clamp(0.04, 1.0),
              child: Container(
                width: 22,
                decoration: BoxDecoration(
                  color: highlight ? scheme.primary : scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: text.labelMedium?.copyWith(
            fontWeight: highlight ? FontWeight.w700 : null,
          ),
        ),
      ],
    );
  }
}

/// The last 4 weeks, one square per day, oldest top-left.
class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.habit, required this.today});

  final Habit habit;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final days = [
      for (var i = 27; i >= 0; i--) today.subtract(Duration(days: i)),
    ];
    final rate = days.where(habit.isDoneOn).length / days.length;
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final d in days)
                  Container(
                    // Seven squares per row, one row per week.
                    width: ((constraints.maxWidth - 6 * 6) / 7).floorToDouble(),
                    height: 18,
                    decoration: BoxDecoration(
                      color: habit.isDoneOn(d)
                          ? habit.color
                          : habit.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            Text(
              '${(rate * 100).round()}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('28 days', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
