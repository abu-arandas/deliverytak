import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';

class SmartSearch extends StatefulWidget {
  final Function(String) onSearch;
  final Function(Map<String, dynamic>) onFilter;
  final List<String> categories;
  final List<String> brands;
  final RangeValues priceRange;

  const SmartSearch({
    super.key,
    required this.onSearch,
    required this.onFilter,
    required this.categories,
    required this.brands,
    required this.priceRange,
  });

  @override
  State<SmartSearch> createState() => _SmartSearchState();
}

class _SmartSearchState extends State<SmartSearch> {
  final _searchController = TextEditingController();
  final _selectedCategories = <String>{};
  final _selectedBrands = <String>{};
  RangeValues _currentPriceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _currentPriceRange = widget.priceRange;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    widget.onFilter({
      'categories': _selectedCategories.toList(),
      'brands': _selectedBrands.toList(),
      'priceRange': {
        'min': _currentPriceRange.start,
        'max': _currentPriceRange.end,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return FB5Container(
      child: FB5Row(
        children: [
          FB5Col(
            classNames: 'col-12 col-md-8',
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: widget.onSearch,
            ),
          ),
          FB5Col(
            classNames: 'col-12 col-md-4',
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    maxChildSize: 0.9,
                    minChildSize: 0.5,
                    builder: (context, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: widget.categories.map((category) {
                                return FilterChip(
                                  label: Text(category),
                                  selected: _selectedCategories.contains(category),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedCategories.add(category);
                                      } else {
                                        _selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Brands',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: widget.brands.map((brand) {
                                return FilterChip(
                                  label: Text(brand),
                                  selected: _selectedBrands.contains(brand),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedBrands.add(brand);
                                      } else {
                                        _selectedBrands.remove(brand);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RangeSlider(
                              values: _currentPriceRange,
                              min: widget.priceRange.start,
                              max: widget.priceRange.end,
                              divisions: 100,
                              labels: RangeLabels(
                                '\$${_currentPriceRange.start.round()}',
                                '\$${_currentPriceRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _currentPriceRange = values;
                                });
                              },
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _applyFilters();
                                  Navigator.pop(context);
                                },
                                child: const Text('Apply Filters'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.filter_list),
              label: const Text('Filters'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
