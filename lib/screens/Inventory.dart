import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<String> _categories = const [
    'All',
    'Bakery',
    'Dairy',
    'Drinks',
    'Produce',
    'Snacks',
    'Frozen',
    'Meat',
  ];

  String _selectedCategory = 'All';
  String _selectedFilter = 'All'; // All, Active, Expiring Soon, Expired
  String _query = '';

  // Dummy inventory data - in real app, this would come from a database
  final List<InventoryItem> _inventoryItems = [
    InventoryItem(
      id: '1',
      name: 'Whole Wheat Bread',
      category: 'Bakery',
      quantity: 5,
      originalPrice: 450,
      sellingPrice: 250,
      expiry: DateTime.now().add(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
      isListed: true,
    ),
    InventoryItem(
      id: '2',
      name: 'Fresh Milk 1L',
      category: 'Dairy',
      quantity: 3,
      originalPrice: 320,
      sellingPrice: 180,
      expiry: DateTime.now().add(const Duration(hours: 18)),
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150',
      isListed: true,
    ),
    InventoryItem(
      id: '3',
      name: 'Organic Tomatoes',
      category: 'Produce',
      quantity: 2,
      originalPrice: 280,
      sellingPrice: 150,
      expiry: DateTime.now().add(const Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1566837945700-30057527ade0',
      isListed: false,
    ),
    InventoryItem(
      id: '4',
      name: 'Greek Yogurt 500g',
      category: 'Dairy',
      quantity: 4,
      originalPrice: 480,
      sellingPrice: 280,
      expiry: DateTime.now().add(const Duration(days: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1559563458-527698bf5295',
      isListed: true,
    ),
    InventoryItem(
      id: '5',
      name: 'Orange Juice 1L',
      category: 'Drinks',
      quantity: 6,
      originalPrice: 350,
      sellingPrice: 200,
      expiry: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1542444459-db63c6b97e09',
      isListed: false,
    ),
  ];

  List<InventoryItem> get _filteredItems {
    final cat = _selectedCategory;
    final filter = _selectedFilter;
    final q = _query.trim().toLowerCase();

    List<InventoryItem> result =
        _inventoryItems.where((item) {
          final matchesCat = (cat == 'All') || item.category == cat;
          final matchesQuery = q.isEmpty || item.name.toLowerCase().contains(q);

          // Filter by status
          final now = DateTime.now();
          final daysUntilExpiry = item.expiry.difference(now).inDays;
          bool matchesFilter = true;
          if (filter == 'Active') {
            matchesFilter = daysUntilExpiry > 1 && item.isListed;
          } else if (filter == 'Expiring Soon') {
            matchesFilter = daysUntilExpiry >= 0 && daysUntilExpiry <= 1;
          } else if (filter == 'Expired') {
            matchesFilter = daysUntilExpiry < 0;
          }

          return matchesCat && matchesQuery && matchesFilter;
        }).toList();

    // Sort by expiry date (soonest first)
    result.sort((a, b) => a.expiry.compareTo(b.expiry));
    return result;
  }

  String _expiryText(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    final days = diff.inDays;
    final hours = diff.inHours;
    if (days < 0) return 'Expired';
    if (days == 0 && hours < 0) return 'Expired';
    if (days == 0) return 'Today';
    if (days == 1) return '1 day left';
    return '$days days left';
  }

  Color _expiryColor(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    final days = diff.inDays;
    if (days < 0) return Colors.red;
    if (days == 0) return Colors.orange;
    if (days <= 1) return Colors.orange.shade300;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearch(context),
            const SizedBox(height: 12),
            _buildChips(context),
            const SizedBox(height: 12),
            _buildFilterChips(context),
            const SizedBox(height: 12),
            Expanded(
              child:
                  _filteredItems.isEmpty
                      ? _buildEmptyState()
                      : _buildInventoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kdefaultPadding,
        kdefaultPadding,
        kdefaultPadding,
        8,
      ),
      child: Row(
        children: [
          const Text(
            'My Inventory',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_inventoryItems.length} items',
              style: TextStyle(
                color: buttonColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: TextField(
        onChanged: (val) => setState(() => _query = val),
        decoration: InputDecoration(
          hintText: 'Search inventory...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildChips(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final label = _categories[i];
          final selected = label == _selectedCategory;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => setState(() => _selectedCategory = label),
            selectedColor: buttonColor.withOpacity(.15),
            labelStyle: TextStyle(
              color: selected ? buttonColor : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            shape: StadiumBorder(
              side: BorderSide(
                color: selected ? buttonColor : Colors.grey.shade300,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _categories.length,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final filters = ['All', 'Active', 'Expiring Soon', 'Expired'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final label = filters[i];
          final selected = label == _selectedFilter;
          return FilterChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => setState(() => _selectedFilter = label),
            selectedColor: buttonColor.withOpacity(.2),
            labelStyle: TextStyle(
              color: selected ? buttonColor : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            shape: StadiumBorder(
              side: BorderSide(
                color: selected ? buttonColor : Colors.grey.shade300,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return ListView.separated(
      padding: const EdgeInsets.all(kdefaultPadding),
      itemCount: _filteredItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _InventoryCard(
          item: item,
          expiryText: _expiryText(item.expiry),
          expiryColor: _expiryColor(item.expiry),
          onTap: () {
            // TODO: Navigate to edit item
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Edit "${item.name}"')));
          },
          onToggleListed: () {
            setState(() {
              item.isListed = !item.isListed;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  item.isListed ? 'Item listed for sale' : 'Item unlisted',
                ),
              ),
            );
          },
          onDelete: () {
            setState(() {
              _inventoryItems.removeWhere((i) => i.id == item.id);
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Deleted "${item.name}"')));
          },
        );
      },
    );
  }
}

// Inventory Item Model
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final double originalPrice;
  final double sellingPrice;
  final DateTime expiry;
  final String imageUrl;
  bool isListed;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.originalPrice,
    required this.sellingPrice,
    required this.expiry,
    required this.imageUrl,
    required this.isListed,
  });

  double get discountPercent =>
      ((originalPrice - sellingPrice) / originalPrice * 100).clamp(0, 100);
}

// Inventory Card Widget
class _InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final String expiryText;
  final Color expiryColor;
  final VoidCallback onTap;
  final VoidCallback onToggleListed;
  final VoidCallback onDelete;

  const _InventoryCard({
    required this.item,
    required this.expiryText,
    required this.expiryColor,
    required this.onTap,
    required this.onToggleListed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final discount = item.discountPercent.round();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                item.imageUrl,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                loadingBuilder: (c, w, p) {
                  if (p == null) return w;
                  return SizedBox(
                    width: 100,
                    height: 120,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder:
                    (_, __, ___) => SizedBox(
                      width: 100,
                      height: 120,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                        ),
                      ),
                    ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (item.isListed)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Listed',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.inventory_2, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: expiryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            expiryText,
                            style: TextStyle(
                              color: expiryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-$discount%',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rs ${item.sellingPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Rs ${item.originalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                item.isListed
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: onToggleListed,
                              color: item.isListed ? buttonColor : Colors.grey,
                              tooltip:
                                  item.isListed ? 'Unlist item' : 'List item',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: onDelete,
                              color: Colors.red.shade300,
                              tooltip: 'Delete item',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
