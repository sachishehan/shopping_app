import 'package:quick/screens/Inventory.dart';

class InventoryService {
  static final InventoryService _instance = InventoryService._internal();
  factory InventoryService() => _instance;
  InventoryService._internal();

  final List<InventoryItem> _items = [
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

  List<InventoryItem> get items => _items;

  void addItem(InventoryItem item) {
    _items.insert(0, item); // Add to beginning of list
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateItem(InventoryItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  InventoryItem createItem({
    required String name,
    required String category,
    required int quantity,
    required double originalPrice,
    required double sellingPrice,
    required DateTime expiry,
    required String imageUrl,
    required bool isListed,
  }) {
    return InventoryItem(
      id: _generateId(),
      name: name,
      category: category,
      quantity: quantity,
      originalPrice: originalPrice,
      sellingPrice: sellingPrice,
      expiry: expiry,
      imageUrl: imageUrl,
      isListed: isListed,
    );
  }
}

