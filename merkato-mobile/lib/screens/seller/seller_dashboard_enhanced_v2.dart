import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/widgets/merkato_logo.dart';
import 'package:merkato_mobile/screens/profile/profile_screen.dart';
import 'seller_products_enhanced.dart';
import 'seller_orders_screen.dart';
import 'seller_analytics_screen.dart';
import 'package:badges/badges.dart' as badges;

class SellerDashboardEnhancedV2 extends ConsumerStatefulWidget {
  const SellerDashboardEnhancedV2({super.key});

  @override
  ConsumerState<SellerDashboardEnhancedV2> createState() => _SellerDashboardEnhancedV2State();
}

class _SellerDashboardEnhancedV2State extends ConsumerState<SellerDashboardEnhancedV2> {
  int _currentIndex = 0;
  Map<String, dynamic>? _analytics;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _notificationCount = 3;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final analyticsResponse = await ApiService.getSellerAnalytics();
      final userData = await ApiService.getUserData();
      
      if (analyticsResponse.statusCode == 200) {
        setState(() {
          _analytics = analyticsResponse.data;
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (error) {
      // Fallback data
      setState(() {
        _analytics = {
          'totalRevenue': 24567.89,
          'totalOrders': 124,
          'pendingOrders': 8,
          'activeProducts': 23,
        };
        _userData = {'name': 'Demo Seller', 'businessName': 'Premium Goods Store'};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  const SellerProductsEnhanced(),
                  const SellerOrdersScreen(),
                  _buildAnalyticsScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    final businessName = _userData?['businessName'] ?? 'My Business';
    final name = _userData?['name'] ?? 'Seller';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F382C), Color(0xFF1E5E4B), Color(0xFF2A7C64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const MerkatoLogoText(fontSize: 18, color: Colors.white),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.store, color: Colors.white.withOpacity(0.9), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Seller Workspace',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: -8, end: -8),
                badgeContent: Text('$_notificationCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                badgeStyle: const badges.BadgeStyle(badgeColor: Color(0xFFEF4444)),
                showBadge: _notificationCount > 0,
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white.withOpacity(0.9)),
                  onPressed: () {
                    setState(() => _notificationCount = 0);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  businessName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsScreen() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentGreen),
      );
    }

    final totalRevenue = _analytics?['totalRevenue'] ?? 0;
    final totalOrders = _analytics?['totalOrders'] ?? 0;
    final pendingOrders = _analytics?['pendingOrders'] ?? 0;
    final activeProducts = _analytics?['activeProducts'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your performance and growth metrics',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildAnalyticsCard(
                'Total Revenue',
                'Birr ${totalRevenue.toStringAsFixed(2)}',
                Icons.attach_money,
                const Color(0xFF10B981),
                '+12.5% this month',
              ),
              _buildAnalyticsCard(
                'Total Orders',
                totalOrders.toString(),
                Icons.shopping_cart_checkout,
                const Color(0xFF3B82F6),
                '+8.2% this month',
              ),
              _buildAnalyticsCard(
                'Pending Orders',
                pendingOrders.toString(),
                Icons.pending_actions,
                const Color(0xFFF59E0B),
                'Needs attention',
              ),
              _buildAnalyticsCard(
                'Active Products',
                activeProducts.toString(),
                Icons.inventory_2,
                const Color(0xFF8B5CF6),
                'Ready to sell',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Quick Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatRow('Average Order Value', 'Birr 198.75', '+5.2%'),
                const Divider(height: 20),
                _buildStatRow('Conversion Rate', '3.8%', '+0.4%'),
                const Divider(height: 20),
                _buildStatRow('Customer Rating', '4.7/5.0', 'Excellent'),
                const Divider(height: 20),
                _buildStatRow('Return Rate', '2.1%', 'Low'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Tips Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F382C), Color(0xFF1E5E4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pro Tips for Sellers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTipItem('📸 Add high-quality product images to increase sales'),
                _buildTipItem('📦 Keep inventory updated to avoid out-of-stock'),
                _buildTipItem('🚚 Process orders quickly for better customer ratings'),
                _buildTipItem('💰 Consider discounts for bulk orders'),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color, String trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String status) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textGrey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status.contains('+') ? const Color(0xFF10B981).withOpacity(0.1) : 
                   status.toLowerCase().contains('low') ? const Color(0xFF10B981).withOpacity(0.1) :
                   const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: status.contains('+') ? const Color(0xFF10B981) : 
                     status.toLowerCase().contains('low') ? const Color(0xFF10B981) :
                     const Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.inventory_2_outlined, 'Products', 0),
              _buildNavItem(Icons.receipt_long_outlined, 'Orders', 1),
              _buildNavItem(Icons.analytics_outlined, 'Analytics', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentGreen.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.accentGreen : AppColors.textGrey,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accentGreen : AppColors.textGrey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}