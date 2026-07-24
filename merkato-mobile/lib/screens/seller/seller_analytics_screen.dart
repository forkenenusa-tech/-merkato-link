import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class SellerAnalyticsScreen extends ConsumerStatefulWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  ConsumerState<SellerAnalyticsScreen> createState() => _SellerAnalyticsScreenState();
}

class _SellerAnalyticsScreenState extends ConsumerState<SellerAnalyticsScreen> {
  Map<String, dynamic>? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final response = await ApiService.getSellerAnalytics();
      if (response.statusCode == 200) {
        setState(() {
          _analytics = response.data;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(),
                  const SizedBox(height: 24),
                  _buildRevenueChart(),
                  const SizedBox(height: 24),
                  _buildTopProducts(),
                  const SizedBox(height: 24),
                  _buildRecentOrders(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Total Revenue',
                'Birr ${_analytics?['totalRevenue']?.toStringAsFixed(0) ?? '0'}',
                Icons.attach_money,
                AppColors.accentGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Total Orders',
                '${_analytics?['totalOrders'] ?? 0}',
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Total Products',
                '${_analytics?['totalProducts'] ?? 0}',
                Icons.inventory_2,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Avg. Rating',
                '${_analytics?['avgRating']?.toStringAsFixed(1) ?? '0.0'}',
                Icons.star,
                AppColors.gold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue This Month',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSimpleChart(),
        ],
      ),
    );
  }

  Widget _buildSimpleChart() {
    final monthlyData = _analytics?['monthlyRevenue'] as List<dynamic>? ?? [];
    if (monthlyData.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textGrey),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(monthlyData.length, (index) {
          final data = monthlyData[index];
          final value = (data['value'] as num?)?.toDouble() ?? 0.0;
          double maxValue = 0;
          for (var item in monthlyData) {
            final itemValue = (item['value'] as num?)?.toDouble() ?? 0.0;
            if (itemValue > maxValue) {
              maxValue = itemValue;
            }
          }
          final height = maxValue > 0 ? (value / maxValue) * 120 : 0.0;

          return Column(
            children: [
              Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['label'] ?? '',
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopProducts() {
    final topProducts = _analytics?['topProducts'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Products',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (topProducts.isEmpty)
            const Text('No products data available', style: TextStyle(color: AppColors.textGrey))
          else
            ...List.generate(topProducts.length, (index) {
              final product = topProducts[index];
              return _buildProductItem(product, index + 1);
            }),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, int rank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.gold : AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rank <= 3 ? Colors.white : AppColors.accentGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Product',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product['sold'] ?? 0} sold',
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Text(
            'Birr ${product['revenue']?.toStringAsFixed(0) ?? '0'}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final recentOrders = _analytics?['recentOrders'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Orders',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (recentOrders.isEmpty)
            const Text('No recent orders', style: TextStyle(color: AppColors.textGrey))
          else
            ...List.generate(recentOrders.length, (index) {
              final order = recentOrders[index];
              return _buildOrderItem(order);
            }),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long, color: AppColors.accentGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order['id']?.toString().substring(0, 8) ?? 'N/A'}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  order['date'] ?? 'N/A',
                  style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Text(
            'Birr ${order['total']?.toStringAsFixed(0) ?? '0'}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }
}
