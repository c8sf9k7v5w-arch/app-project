import 'package:flutter/material.dart';

import 'models.dart';

const services = <Service>[
  Service(
    id: 'cut',
    name: 'Haircut & Style',
    description: 'Wash, precision cut and blow-dry finish.',
    minutes: 45,
    price: 35,
    icon: Icons.content_cut,
  ),
  Service(
    id: 'color',
    name: 'Full Color',
    description: 'Single-process color with gloss treatment.',
    minutes: 90,
    price: 80,
    icon: Icons.palette_outlined,
  ),
  Service(
    id: 'beard',
    name: 'Beard Trim',
    description: 'Shape-up with hot towel and beard oil.',
    minutes: 20,
    price: 18,
    icon: Icons.face_retouching_natural,
  ),
  Service(
    id: 'nails',
    name: 'Manicure',
    description: 'Nail shaping, cuticle care and polish.',
    minutes: 40,
    price: 28,
    icon: Icons.back_hand_outlined,
  ),
  Service(
    id: 'spa',
    name: 'Scalp Spa Ritual',
    description: 'Exfoliating scrub, massage and mask.',
    minutes: 60,
    price: 55,
    icon: Icons.spa_outlined,
  ),
];

const stylists = <Stylist>[
  Stylist(
    name: 'Giulia Rossi',
    role: 'Senior stylist',
    color: Color(0xFFE57373),
  ),
  Stylist(name: 'Marco Bianchi', role: 'Barber', color: Color(0xFF64B5F6)),
  Stylist(name: 'Sara Conti', role: 'Colorist', color: Color(0xFF81C784)),
];

/// Opening hours: 9:00 to 18:00, one slot every 30 minutes.
List<DateTime> slotsFor(DateTime day) {
  final slots = <DateTime>[];
  for (var m = 9 * 60; m < 18 * 60; m += 30) {
    slots.add(DateTime(day.year, day.month, day.day, m ~/ 60, m % 60));
  }
  return slots;
}

DateTime closingTime(DateTime day) =>
    DateTime(day.year, day.month, day.day, 18);

/// Fake "already taken" slots so the calendar looks realistic.
bool isTakenByOthers(DateTime slot, Stylist stylist) {
  final seed =
      slot.day * 31 + slot.hour * 7 + slot.minute + stylist.name.length;
  return seed % 5 == 0 || seed % 7 == 0;
}
