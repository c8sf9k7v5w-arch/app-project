import 'package:flutter/material.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../store.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.service});

  final Service service;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late final List<DateTime> _days;
  late DateTime _day;
  Stylist _stylist = stylists.first;
  DateTime? _slot;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _days = [for (var i = 0; i < 14; i++) today.add(Duration(days: i))]
        .where((d) => d.weekday != DateTime.sunday)
        .toList();
    _day = _days.first;
  }

  void _confirm() async {
    final store = StoreScope.read(context);
    final booking = store.book(widget.service, _stylist, _slot!);
    await showDialog<void>(
      context: context,
      builder: (context) => _ConfirmedDialog(booking: booking),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final slots = slotsFor(_day);

    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text('Stylist', style: text.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stylists.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final s = stylists[i];
                final selected = s == _stylist;
                return GestureDetector(
                  onTap: () => setState(() {
                    _stylist = s;
                    _slot = null;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 112,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: selected
                            ? scheme.primary
                            : scheme.outlineVariant,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: s.color,
                          child: Text(
                            s.initials,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.name.split(' ').first,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelLarge,
                        ),
                        Text(
                          s.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('Date', style: text.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final d = _days[i];
                final selected = sameDay(d, _day);
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() {
                    _day = d;
                    _slot = null;
                  }),
                  child: Ink(
                    width: 60,
                    decoration: BoxDecoration(
                      color: selected
                          ? scheme.primary
                          : scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekday(d),
                          style: text.labelMedium?.copyWith(
                            color: selected
                                ? scheme.onPrimary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${d.day}',
                          style: text.titleLarge?.copyWith(
                            color: selected
                                ? scheme.onPrimary
                                : scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('Time', style: text.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in slots)
                ChoiceChip(
                  label: Text(time(slot)),
                  selected: _slot == slot,
                  showCheckmark: false,
                  onSelected:
                      store.isAvailable(
                        slot,
                        _stylist,
                        minutes: widget.service.minutes,
                      )
                      ? (_) => setState(() => _slot = slot)
                      : null,
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price(widget.service.price),
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _slot == null
                          ? 'Pick a time'
                          : '${shortDate(_slot!)} · ${time(_slot!)}',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: _slot == null ? null : _confirm,
                icon: const Icon(Icons.check),
                label: const Text('Book now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmedDialog extends StatelessWidget {
  const _ConfirmedDialog({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      icon: Icon(Icons.check_circle, color: scheme.primary, size: 48),
      title: const Text('You\'re booked!'),
      content: Text(
        '${booking.service.name} with ${booking.stylist.name}\n'
        '${shortDate(booking.start)} at ${time(booking.start)}\n\n'
        'Booking code ${booking.id}',
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
