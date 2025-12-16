import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Dummy orders data - purchases
  final List<Order> _purchases = [
    Order(
      id: 'P001',
      type: OrderType.purchase,
      items: [
        OrderItem(
          name: 'Brown Bread Loaf',
          quantity: 2,
          price: 350,
          imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
        ),
        OrderItem(
          name: 'Greek Yogurt 500g',
          quantity: 1,
          price: 480,
          imageUrl: 'https://images.unsplash.com/photo-1559563458-527698bf5295',
        ),
      ],
      sellerName: 'FreshMart',
      totalAmount: 1180,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: 'P002',
      type: OrderType.purchase,
      items: [
        OrderItem(
          name: 'Cherry Tomatoes Box',
          quantity: 1,
          price: 290,
          imageUrl: 'https://www.lesuipackaging.com/uploads/image/20230117/10/disposable-fruit-cup-containers_1673922298.jpg',
        ),
      ],
      sellerName: 'Green Basket',
      totalAmount: 290,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Order(
      id: 'P003',
      type: OrderType.purchase,
      items: [
        OrderItem(
          name: 'Orange Juice 1L',
          quantity: 3,
          price: 310,
          imageUrl: 'https://www.verywellhealth.com/thmb/90ZExhTVdD7A4vaC3Uc4-4Btb-c=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/VWH-GettyImages-1465038961-90038f19760a4d0b8503f28598535c8b.jpg',
        ),
      ],
      sellerName: 'Thirst Quench',
      totalAmount: 930,
      status: OrderStatus.pending,
      orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Order(
      id: 'P004',
      type: OrderType.purchase,
      items: [
        OrderItem(
          name: 'Chicken Breast 1kg',
          quantity: 1,
          price: 1190,
          imageUrl: 'https://www.foodcoachforme.com/wp-content/uploads/2020/03/chicken-with-garlic-and-rosemary-scaled.jpg',
        ),
      ],
      sellerName: 'Butcher\'s Hub',
      totalAmount: 1190,
      status: OrderStatus.cancelled,
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Dummy orders data - sales
  final List<Order> _sales = [
    Order(
      id: 'S001',
      type: OrderType.sale,
      items: [
        OrderItem(
          name: 'Whole Wheat Bread',
          quantity: 2,
          price: 250,
          imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
        ),
      ],
      buyerName: 'John Doe',
      totalAmount: 500,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      deliveryDate: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Order(
      id: 'S002',
      type: OrderType.sale,
      items: [
        OrderItem(
          name: 'Fresh Milk 1L',
          quantity: 1,
          price: 180,
          imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150',
        ),
        OrderItem(
          name: 'Greek Yogurt 500g',
          quantity: 2,
          price: 280,
          imageUrl: 'https://images.unsplash.com/photo-1559563458-527698bf5295',
        ),
      ],
      buyerName: 'Jane Smith',
      totalAmount: 740,
      status: OrderStatus.confirmed,
      orderDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Order(
      id: 'S003',
      type: OrderType.sale,
      items: [
        OrderItem(
          name: 'Organic Tomatoes',
          quantity: 1,
          price: 150,
          imageUrl: 'https://images.unsplash.com/photo-1566837945700-30057527ade0',
        ),
      ],
      buyerName: 'Mike Johnson',
      totalAmount: 150,
      status: OrderStatus.pending,
      orderDate: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  List<Order> get _filteredOrders {
    final orders = _tabController.index == 0 ? _purchases : _sales;
    if (_selectedFilter == 'All') return orders;
    return orders.where((order) {
      switch (_selectedFilter) {
        case 'Pending':
          return order.status == OrderStatus.pending;
        case 'Confirmed':
          return order.status == OrderStatus.confirmed;
        case 'Delivered':
          return order.status == OrderStatus.delivered;
        case 'Cancelled':
          return order.status == OrderStatus.cancelled;
        default:
          return true;
      }
    }).toList()
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} min ago';
      }
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildFilterChips(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(_purchases),
                  _buildOrdersList(_sales),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          kdefaultPadding, kdefaultPadding, kdefaultPadding, 8),
      child: Row(
        children: [
          const Text(
            'My Orders',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Search orders
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search orders coming soon')),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      decoration: BoxDecoration(

        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          
        ),
        onTap: (index) {
          setState(() {
            _selectedFilter = 'All';
          });
        },
        tabs: const [
          Tab(text: '  My Purchases   '  ),
          Tab(text: '  My Sales   '),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Confirmed', 'Delivered', 'Cancelled'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(kdefaultPadding, 12, kdefaultPadding, 8),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
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
                    color: selected ? buttonColor : Colors.grey.shade300),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: filters.length,
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    final filtered = _filteredOrders;
    
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(kdefaultPadding),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = filtered[index];
        return _OrderCard(
          order: order,
          statusColor: _getStatusColor(order.status),
          statusText: _getStatusText(order.status),
          dateText: _formatDate(order.orderDate),
          onTap: () {
            _showOrderDetails(context, order);
          },
          onAction: () {
            _handleOrderAction(context, order);
          },
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }

  void _handleOrderAction(BuildContext context, Order order) {
    if (order.status == OrderStatus.pending) {
      if (order.type == OrderType.purchase) {
        // Buyer can cancel
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cancel Order'),
            content: const Text('Are you sure you want to cancel this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    order.status = OrderStatus.cancelled;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order cancelled')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
        );
      } else {
        // Seller can confirm
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Order'),
            content: const Text('Confirm this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    order.status = OrderStatus.confirmed;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order confirmed')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: buttonColor),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      }
    } else if (order.status == OrderStatus.confirmed && order.type == OrderType.sale) {
      // Seller can mark as delivered
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mark as Delivered'),
          content: const Text('Mark this order as delivered?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  order.status = OrderStatus.delivered;
                  order.deliveryDate = DateTime.now();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order marked as delivered')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: buttonColor),
              child: const Text('Mark Delivered'),
            ),
          ],
        ),
      );
    }
  }
}

// Order Models
enum OrderType { purchase, sale }
enum OrderStatus { pending, confirmed, delivered, cancelled }

class Order {
  final String id;
  final OrderType type;
  final List<OrderItem> items;
  final double totalAmount;
  OrderStatus status;
  final DateTime orderDate;
  DateTime? deliveryDate;
  String? sellerName;
  String? buyerName;

  Order({
    required this.id,
    required this.type,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.sellerName,
    this.buyerName,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

// Order Card Widget
class _OrderCard extends StatelessWidget {
  final Order order;
  final Color statusColor;
  final String statusText;
  final String dateText;
  final VoidCallback onTap;
  final VoidCallback onAction;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.statusText,
    required this.dateText,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final otherParty = order.type == OrderType.purchase
        ? order.sellerName ?? 'Seller'
        : order.buyerName ?? 'Buyer';

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
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID, Status, Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Items preview
              ...order.items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Qty: ${item.quantity} × Rs ${item.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ ${order.items.length - 2} more item${order.items.length - 2 > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const Divider(height: 24),
              // Footer: Other party, Total, Action
              Row(
                children: [
                  Icon(
                    order.type == OrderType.purchase
                        ? Icons.storefront
                        : Icons.person,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      otherParty,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Text(
                    'Rs ${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (order.status == OrderStatus.pending ||
                      (order.status == OrderStatus.confirmed &&
                          order.type == OrderType.sale))
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          foregroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          order.status == OrderStatus.pending
                              ? (order.type == OrderType.purchase
                                  ? 'Cancel'
                                  : 'Confirm')
                              : 'Deliver',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Order Details Bottom Sheet
class _OrderDetailsSheet extends StatelessWidget {
  final Order order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    final otherParty = order.type == OrderType.purchase
        ? order.sellerName ?? 'Seller'
        : order.buyerName ?? 'Buyer';

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(kdefaultPadding),
            child: Row(
              children: [
                const Text(
                  'Order Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Info
                  _buildDetailRow('Order ID', order.id),
                  _buildDetailRow(
                    'Status',
                    order.status.toString().split('.').last.toUpperCase(),
                  ),
                  _buildDetailRow(
                    'Date',
                    '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                  ),
                  if (order.deliveryDate != null)
                    _buildDetailRow(
                      'Delivered',
                      '${order.deliveryDate!.day}/${order.deliveryDate!.month}/${order.deliveryDate!.year}',
                    ),
                  _buildDetailRow(
                    order.type == OrderType.purchase ? 'Seller' : 'Buyer',
                    otherParty,
                  ),
                  const SizedBox(height: 20),
                  // Items
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Quantity: ${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rs ${(item.price * item.quantity).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: buttonColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Rs ${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
