import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/filter_controller.dart';

class FilterDrawer extends ConsumerWidget {
  const FilterDrawer({super.key});

  final categories = const ['electronics', 'jewelery', 'men\'s clothing', 'women\'s clothing'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoriesProvider);
    final price = ref.watch(priceRangeProvider);

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Filter By Category', style: TextStyle(fontSize: 18)),
          ...categories.map((cat) {
            return CheckboxListTile(
              title: Text(cat),
              value: selected.contains(cat),
              onChanged: (val) {
                final notifier = ref.read(selectedCategoriesProvider.notifier);
                if (val == true) {
                  notifier.state = [...selected, cat];
                } else {
                  notifier.state = selected.where((c) => c != cat).toList();
                }
              },
            );
          }).toList(),
          const Divider(),
          const Text('Price Range', style: TextStyle(fontSize: 18)),
          RangeSlider(
            min: 0,
            max: 1000,
            divisions: 10,
            labels: RangeLabels('\$${price.start.toInt()}', '\$${price.end.toInt()}'),
            values: price,
            onChanged: (range) {
              ref.read(priceRangeProvider.notifier).state = range;
            },
          ),
        ],
      ),
    );
  }
}
