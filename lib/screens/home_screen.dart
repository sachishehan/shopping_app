// import 'package:flutter/material.dart';
// import 'package:quick/constant/colors.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: const Text('Home Screen'),
//       ),
//     );
    
//   }
// }
import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Dummy data model ---
  final List<String> _categories = const [
    'All', 'Bakery', 'Dairy', 'Drinks', 'Produce', 'Snacks', 'Frozen', 'Meat'
  ];

  String _selectedCategory = 'All';
  String _selectedSort = 'Expiring soon';
  String _query = '';

  final List<_Deal> _deals = [
    _Deal(
      id: '1',
      name: 'Brown Bread Loaf',
      shop: 'FreshMart',
      category: 'Bakery',
      price: 350,
      originalPrice: 700,
      distanceKm: 1.2,
      expiry: DateTime.now().add(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
    ),
    _Deal(
      id: '2',
      name: 'Greek Yogurt 500g',
      shop: 'Daily Dairy',
      category: 'Dairy',
      price: 480,
      originalPrice: 960,
      distanceKm: 0.9,
      expiry: DateTime.now().add(const Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1559563458-527698bf5295',
    ),
    _Deal(
      id: '3',
      name: 'Cherry Tomatoes Box',
      shop: 'Green Basket',
      category: 'Produce',
      price: 290,
      originalPrice: 520,
      distanceKm: 2.4,
      expiry: DateTime.now().add(const Duration(days: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1566837945700-30057527ade0',
    ),
    _Deal(
      id: '4',
      name: 'Chicken Breast 1kg',
      shop: 'Butcher’s Hub',
      category: 'Meat',
      price: 119,
      originalPrice: 170,
      distanceKm: 3.1,
      expiry: DateTime.now().add(const Duration(hours: 20)),
      imageUrl: 'https://images.unsplash.com/photo-1604908554027-9129f71fd9e6',
    ),
    _Deal(
      id: '5',
      name: 'Chocolate Cookies',
      shop: 'SnackPoint',
      category: 'Snacks',
      price: 250,
      originalPrice: 500,
      distanceKm: 1.8,
      expiry: DateTime.now().add(const Duration(days: 4)),
      imageUrl: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e',
    ),
    _Deal(
      id: '6',
      name: 'Orange Juice 1L',
      shop: 'Thirst Quench',
      category: 'Drinks',
      price: 310,
      originalPrice: 620,
      distanceKm: 0.7,
      expiry: DateTime.now().add(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1542444459-db63c6b97e09',
    ),
  ];

  // --- Helpers ---
  List<_Deal> get _filteredDeals {
    final cat = _selectedCategory;
    final q = _query.trim().toLowerCase();

    List<_Deal> result = _deals.where((d) {
      final matchesCat = (cat == 'All') || d.category == cat;
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.shop.toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();

    switch (_selectedSort) {
      case 'Biggest discount':
        result.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
        break;
      case 'Nearest':
        result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'Expiring soon':
      default:
        result.sort((a, b) => a.expiry.compareTo(b.expiry));
    }
    return result;
  }

  String _expiryText(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    final days = diff.inDays;
    if (days < 0) return 'Expired';
    if (days == 0) return 'Today';
    return '$days d left';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // TODO: Navigate to "Post a deal" flow
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Post a deal — coming soon')),
      //     );
      //   },
      //   backgroundColor: buttonColor,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Post a deal'),
      // ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildSearch(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildChips(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildBanner(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Near-expiry deals',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    _buildSortDropdown(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(kdefaultPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final deal = _filteredDeals[index];
                    return _DealCard(
                      deal: deal,
                      expiryText: _expiryText(deal.expiry),
                      onTap: () {
                        // TODO: Navigate to details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Open "${deal.name}"')),
                        );
                      },
                      onPick: () {
                        // TODO: Add to cart / start checkout
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Picked "${deal.name}"')),
                        );
                      },
                    );
                  },
                  childCount: _filteredDeals.length,
                ),
              ),
            ),
            if (_filteredDeals.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('No deals match your filters'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kdefaultPadding, kdefaultPadding, kdefaultPadding, 8),
      child: Row(
        children: [
          SizedBox(
            height: 36,
            child: Image.asset(
              'assets/images/Logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.local_grocery_store, size: 36),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'QuickPick',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifications',
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
          hintText: 'Search deals, shops, items…',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
              side: BorderSide(color: selected ? buttonColor : Colors.grey.shade300),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _categories.length,
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(.10),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.eco_outlined, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Save food, save money',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Grab near-expiry items up to 60% off and reduce waste.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedSort,
        items: const [
          DropdownMenuItem(value: 'Expiring soon', child: Text('Expiring soon')),
          DropdownMenuItem(value: 'Biggest discount', child: Text('Biggest discount')),
          DropdownMenuItem(value: 'Nearest', child: Text('Nearest')),
        ],
        onChanged: (v) => setState(() => _selectedSort = v ?? _selectedSort),
      ),
    );
  }
}

// --- Models & UI bits ---

class _Deal {
  final String id;
  final String name;
  final String shop;
  final String category;
  final double price;
  final double originalPrice;
  final double distanceKm;
  final DateTime expiry;
  final String imageUrl;

  _Deal({
    required this.id,
    required this.name,
    required this.shop,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.distanceKm,
    required this.expiry,
    required this.imageUrl,
  });

  double get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).clamp(0, 100);
}

class _DealCard extends StatelessWidget {
  final _Deal deal;
  final String expiryText;
  final VoidCallback onTap;
  final VoidCallback onPick;

  const _DealCard({
    required this.deal,
    required this.expiryText,
    required this.onTap,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final discount = deal.discountPercent.round();
    final expired = expiryText == 'Expired';
    return InkWell(
      onTap: expired ? null : onTap,
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
            )
          ],
        ),
        child: Column(
          children: [
            // image + discount badge
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        deal.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (c, w, p) {
                          if (p == null) return w;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported_outlined, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-$discount%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: expired ? Colors.red : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        expiryText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.storefront, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          deal.shop,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.place, size: 14, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        '${deal.distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs ${deal.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rs ${deal.originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: expired ? null : onPick,
                        child: const Text('Pick'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
