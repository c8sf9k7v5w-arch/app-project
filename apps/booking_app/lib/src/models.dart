import 'package:flutter/material.dart';

class Service {
  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.minutes,
    required this.price,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final int minutes;
  final double price;
  final IconData icon;
}

class Stylist {
  const Stylist({required this.name, required this.role, required this.color});

  final String name;
  final String role;
  final Color color;

  String get initials => name.split(' ').map((p) => p[0]).take(2).join();
}

class Booking {
  Booking({
    required this.id,
    required this.service,
    required this.stylist,
    required this.start,
  });

  final String id;
  final Service service;
  final Stylist stylist;
  final DateTime start;

  DateTime get end => start.add(Duration(minutes: service.minutes));
}
