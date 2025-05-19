import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);

final priceRangeProvider =
StateProvider<RangeValues>((ref) => const RangeValues(0, 1000));
