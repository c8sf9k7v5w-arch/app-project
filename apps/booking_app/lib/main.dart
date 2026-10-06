import 'package:flutter/material.dart';

import 'src/screens/bookings_screen.dart';
import 'src/screens/services_screen.dart';
import 'src/store.dart';

void main() => runApp(BookingApp(store: BookingStore()));

class BookingApp extends StatelessWidget {
  const BookingApp({super.key, required this.store});

  final BookingStore store;

  @override
  Widget build(BuildContext context) {
    return StoreScope(
      store: store,
      child: MaterialApp(
        title: 'Glow Studio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF8E4A6B),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFBF7F9),
        ),
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final count = StoreScope.of(context).upcoming.length;
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [ServicesScreen(), BookingsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: const Icon(Icons.event_note_outlined),
            ),
            selectedIcon: const Icon(Icons.event_note),
            label: 'My bookings',
          ),
        ],
      ),
    );
  }
}
