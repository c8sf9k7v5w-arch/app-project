import 'package:flutter/material.dart';

import 'src/habits.dart';
import 'src/screens/stats_screen.dart';
import 'src/screens/today_screen.dart';

void main() => runApp(HabitApp(store: HabitStore.demo()));

class HabitApp extends StatelessWidget {
  const HabitApp({super.key, required this.store});

  final HabitStore store;

  @override
  Widget build(BuildContext context) {
    return HabitScope(
      store: store,
      child: MaterialApp(
        title: 'Streaks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF3F51B5),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
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
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [TodayScreen(), StatsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
