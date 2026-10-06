import 'package:flutter/widgets.dart';

import 'data.dart';
import 'models.dart';

class BookingStore extends ChangeNotifier {
  final List<Booking> _bookings = [];
  int _nextId = 1;

  List<Booking> get upcoming {
    final list = _bookings.where((b) => b.end.isAfter(DateTime.now())).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return List.unmodifiable(list);
  }

  /// Whether [stylist] is free from [slot] for [minutes], within opening hours.
  bool isAvailable(DateTime slot, Stylist stylist, {int minutes = 30}) {
    final end = slot.add(Duration(minutes: minutes));
    if (slot.isBefore(DateTime.now())) return false;
    if (end.isAfter(closingTime(slot))) return false;
    if (isTakenByOthers(slot, stylist)) return false;
    return !_bookings.any(
      (b) =>
          b.stylist == stylist && slot.isBefore(b.end) && b.start.isBefore(end),
    );
  }

  Booking book(Service service, Stylist stylist, DateTime start) {
    final booking = Booking(
      id: 'BK-${(_nextId++).toString().padLeft(4, '0')}',
      service: service,
      stylist: stylist,
      start: start,
    );
    _bookings.add(booking);
    notifyListeners();
    return booking;
  }

  void cancel(Booking booking) {
    _bookings.remove(booking);
    notifyListeners();
  }
}

class StoreScope extends InheritedNotifier<BookingStore> {
  const StoreScope({
    super.key,
    required BookingStore store,
    required super.child,
  }) : super(notifier: store);

  static BookingStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;

  /// Reads the store without rebuilding when it changes (for callbacks).
  static BookingStore read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
