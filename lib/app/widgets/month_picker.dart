import 'package:flutter/material.dart';

/// Shows a simple month-only picker (year + month) and returns a DateTime
/// normalized to the first day of the selected month, or null if cancelled.
Future<DateTime?> showMonthPickerDialog(BuildContext context, {DateTime? initial}) {
  final now = DateTime.now();
  initial ??= DateTime(now.year, now.month, 1);

  int selectedYear = initial.year;
  int selectedMonth = initial.month;

  final years = List.generate(11, (i) => now.year - 5 + i); // -5..+5

  return showDialog<DateTime>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Select month'),
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedYear,
                items: years.map((y) => DropdownMenuItem(value: y, child: Text(y.toString()))).toList(),
                onChanged: (v) => setState(() => selectedYear = v ?? selectedYear),
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedMonth,
                items: List.generate(12, (i) => i + 1)
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text('${_monthName(m)}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedMonth = v ?? selectedMonth),
                decoration: const InputDecoration(labelText: 'Month'),
              ),
            ],
          );
        }),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(DateTime(selectedYear, selectedMonth, 1)), child: const Text('Select')),
        ],
      );
    },
  );
}

String _monthName(int m) {
  const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return names[m - 1];
}
