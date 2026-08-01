import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/screens/auth/login_screen.dart';
import 'package:merkato_mobile/screens/customer/cart_screen.dart';
import 'package:merkato_mobile/screens/customer/wishlist_screen.dart';
import 'package:merkato_mobile/screens/customer/order_tracking_screen.dart';
import 'package:merkato_mobile/screens/profile/profile_screen.dart';
import 'package:merkato_mobile/screens/seller/seller_dashboard_enhanced.dart';
import 'package:merkato_mobile/screens/driver/driver_dashboard_screen.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/widgets/home/custom_bottom_nav.dart';
import 'package:merkato_mobile/widgets/home/home_widgets.dart';
import 'package:merkato_mobile/widgets/product_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await ApiService.getUserData();
    if (mounted) {
      setState(() => _userData = userData);
    }
  }

  Future<void> _logout() async {
    await ApiService.clearToken();
    await ApiService.clearUserData();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            _buildPlaceholder('Categories', Icons.grid_view),
            _buildPlaceholder('Scan & Pay', Icons.qr_code_scanner),
            const OrderTrackingScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: MerkatoBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeader(
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        const SliverToBoxAdapter(child: HomeSearchBar()),
        const SliverToBoxAdapter(child: HomeLocationBar()),
        const SliverToBoxAdapter(child: HeroCarousel()),
        const SliverToBoxAdapter(child: QuickServicesRow()),
        const SliverToBoxAdapter(child: ValueBadgesRow()),
        const SliverToBoxAdapter(child: CategoryCirclesRow()),
        const SliverToBoxAdapter(child: FlashDealsSection()),
        const SliverToBoxAdapter(child: LocalMarketSection()),
        const SliverToBoxAdapter(child: CoinsRewardsBanner()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended for You',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text('See All >', style: TextStyle(fontSize: 12, color: AppColors.accentGreen, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const ProductGrid(),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: TrendingNearYouSection()),
      ],
    );
  }

  Widget _buildAccountTab() {
    final name = _userData?['name'] ?? 'User';
    final email = _userData?['email'] ?? '';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.lightGreen,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (email.isNotEmpty)
            Text(email, style: const TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 32),
          _accountTile(Icons.shopping_cart, 'My Cart', () => _navigateToCart()),
          _accountTile(Icons.favorite, 'My Wishlist', () => _navigateToWishlist()),
          _accountTile(Icons.receipt_long, 'My Orders', () => setState(() => _currentIndex = 3)),
          _accountTile(Icons.account_balance_wallet, 'Wallet', () {}),
          _accountTile(Icons.monetization_on, 'Coins & Rewards', () {}),
          _accountTile(Icons.settings, 'Settings', () {}),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.errorRed,
                side: const BorderSide(color: AppColors.errorRed),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  void _navigateToWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WishlistScreen()),
    );
  }

  Widget _accountTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentGreen),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textGrey),
      onTap: onTap,
    );
  }

  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.accentGreen.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
          const SizedBox(height: 8),
          const Text('Coming soon', style: TextStyle(color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    final name = _userData?['name'] ?? 'Guest';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryGreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'G',
                    style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: () { Navigator.pop(context); setState(() => _currentIndex = 0); }),
          ListTile(leading: const Icon(Icons.person), title: const Text('My Profile'), onTap: () { Navigator.pop(context); setState(() => _currentIndex = 4); }),
          ListTile(leading: const Icon(Icons.grid_view), title: const Text('Categories'), onTap: () { Navigator.pop(context); setState(() => _currentIndex = 1); }),
          ListTile(leading: const Icon(Icons.shopping_cart), title: const Text('My Cart'), onTap: () { Navigator.pop(context); _navigateToCart(); }),
          ListTile(leading: const Icon(Icons.favorite), title: const Text('My Wishlist'), onTap: () { Navigator.pop(context); _navigateToWishlist(); }),
          ListTile(leading: const Icon(Icons.receipt_long), title: const Text('Orders'), onTap: () { Navigator.pop(context); setState(() => _currentIndex = 3); }),
          if (_userData?['role'] == 'seller')
            ListTile(
              leading: const Icon(Icons.storefront, color: AppColors.accentGreen),
              title: const Text('Seller Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerDashboardEnhanced()));
              },
            ),
          if (_userData?['role'] == 'driver')
            ListTile(
              leading: const Icon(Icons.local_shipping, color: AppColors.accentGreen),
              title: const Text('Driver Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDashboardScreen()));
              },
            ),
          ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & Support'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.errorRed),
            title: const Text('Logout', style: TextStyle(color: AppColors.errorRed)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
