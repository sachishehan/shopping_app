import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick/screens/login_page.dart';
import 'package:quick/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;

  // Dummy statistics - in real app, fetch from backend
  int _itemsSold = 24;
  int _itemsBought = 18;
  int _activeListings = 5;
  double _totalSavings = 3450.0;
  double _totalEarnings = 5670.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('userName') ?? 'Guest User';
        _userEmail = prefs.getString('email') ?? 'guest@example.com';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userName = 'Guest User';
        _userEmail = 'guest@example.com';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (confirm == true && context.mounted) {
      // Clear user data and set logged in to false
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await AuthService.setLoggedIn(false);

      // Navigate to login
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildProfileSection()),
                    SliverToBoxAdapter(child: _buildStatsSection()),
                    SliverToBoxAdapter(child: _buildQuickActions()),
                    SliverToBoxAdapter(child: _buildMenuSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
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
            'Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(kdefaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor.withOpacity(0.1),
                    border: Border.all(color: buttonColor, width: 3),
                  ),
                  child: Icon(Icons.person, size: 60, color: buttonColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change photo coming soon'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // User Name
            Text(
              _userName ?? 'Guest User',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            // Email
            Text(
              _userEmail ?? 'guest@example.com',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            // Edit Profile Button
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile coming soon')),
                );
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: buttonColor,
                side: BorderSide(color: buttonColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Items Sold',
                  _itemsSold.toString(),
                  Icons.sell,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Items Bought',
                  _itemsBought.toString(),
                  Icons.shopping_bag,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Listings',
                  _activeListings.toString(),
                  Icons.inventory_2,
                  buttonColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Savings',
                  'Rs ${_totalSavings.toStringAsFixed(0)}',
                  Icons.savings,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: buttonColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs ${_totalEarnings.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kdefaultPadding,
        20,
        kdefaultPadding,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'My Orders',
                  Icons.receipt_long,
                  Colors.purple,
                  () {
                    // Navigate to orders - handled by bottom nav
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('View your orders')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'My Inventory',
                  Icons.inventory_2,
                  buttonColor,
                  () {
                    // Navigate to inventory - handled by bottom nav
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('View your inventory')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile coming soon')),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification settings coming soon'),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment methods coming soon'),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Addresses',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Addresses coming soon')),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & support coming soon'),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'QuickPick',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.local_grocery_store,
                        size: 48,
                      ),
                      children: [
                        const Text(
                          'A platform to buy and sell near-expiry foods at discounted prices.',
                        ),
                      ],
                    );
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: Colors.red,
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: Colors.grey.shade200,
    );
  }
}
