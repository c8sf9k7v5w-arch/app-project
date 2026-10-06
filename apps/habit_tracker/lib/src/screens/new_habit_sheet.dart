import 'package:flutter/material.dart';

import '../habits.dart';

const _icons = [
  Icons.fitness_center,
  Icons.directions_walk,
  Icons.bedtime_outlined,
  Icons.restaurant_outlined,
  Icons.school_outlined,
  Icons.brush_outlined,
  Icons.savings_outlined,
  Icons.phone_disabled_outlined,
];

const _colors = [
  Color(0xFFEF5350),
  Color(0xFFFFA726),
  Color(0xFF66BB6A),
  Color(0xFF26A69A),
  Color(0xFF42A5F5),
  Color(0xFF5C6BC0),
  Color(0xFFAB47BC),
  Color(0xFFEC407A),
];

class NewHabitSheet extends StatefulWidget {
  const NewHabitSheet({super.key, required this.store});

  final HabitStore store;

  @override
  State<NewHabitSheet> createState() => _NewHabitSheetState();
}

class _NewHabitSheetState extends State<NewHabitSheet> {
  final _name = TextEditingController();
  IconData _icon = _icons.first;
  Color _color = _colors[4];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    widget.store.add(name, _icon, _color);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New habit', style: text.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Stretch for 5 minutes',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 20),
          Text('Icon', style: text.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final icon in _icons)
                IconButton(
                  isSelected: icon == _icon,
                  style: IconButton.styleFrom(
                    backgroundColor: icon == _icon
                        ? _color.withValues(alpha: 0.2)
                        : null,
                  ),
                  onPressed: () => setState(() => _icon = icon),
                  icon: Icon(icon, color: icon == _icon ? _color : null),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Color', style: text.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in _colors)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: c,
                    child: c == _color
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: _name.text.trim().isEmpty ? null : _save,
            child: const Text('Add habit'),
          ),
        ],
      ),
    );
  }
}
