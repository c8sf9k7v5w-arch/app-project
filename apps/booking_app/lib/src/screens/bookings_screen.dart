import 'package:flutter/material.dart';

import '../format.dart';
import '../models.dart';
import '../store.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final bookings = store.upcoming;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('My bookings')),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_available, size: 64, color: scheme.outline),
                  const SizedBox(height: 12),
                  Text('No upcoming bookings', style: text.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Book a service and it will show up here.',
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _BookingTile(
                booking: bookings[i],
                onCancel: () => _cancel(context, store, bookings[i]),
              ),
            ),
    );
  }

  Future<void> _cancel(
    BuildContext context,
    BookingStore store,
    Booking b,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          '${b.service.name} on ${shortDate(b.start)} at ${time(b.start)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (ok == true) store.cancel(b);
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking, required this.onCancel});

  final Booking booking;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(weekday(booking.start), style: text.labelMedium),
                Text(
                  '${booking.start.day}',
                  style: text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(time(booking.start), style: text.labelMedium),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.service.name, style: text.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'with ${booking.stylist.name}',
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${time(booking.start)}–${time(booking.end)} · ${price(booking.service.price)}',
                  style: text.bodySmall,
                ),
                Text(
                  booking.id,
                  style: text.labelSmall?.copyWith(color: scheme.outline),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cancel booking',
            onPressed: onCancel,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
