import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final response = await ApiService.getOrders();
      if (response.statusCode == 200) {
        setState(() {
          _orders = response.data['orders'] ?? [];
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', 'pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Processing', 'processing'),
            const SizedBox(width: 8),
            _buildFilterChip('Shipped', 'shipped'),
            const SizedBox(width: 8),
            _buildFilterChip('Delivered', 'delivered'),
            const SizedBox(width: 8),
            _buildFilterChip('Cancelled', 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: AppColors.accentGreen,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No orders yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start shopping to see your orders here',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order['id']?.toString().substring(0, 8) ?? 'N/A'}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildOrderTimeline(status),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Items: ${order['items']?.length ?? 0}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            (order['items'] as List?)?.length ?? 0,
            (index) {
              final item = order['items'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${item['quantity']}x ',
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                    Expanded(
                      child: Text(
                        item['name'] ?? 'Product',
                        style: const TextStyle(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Birr ${item['price']?.toStringAsFixed(0) ?? '0'}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'Birr ${order['total']?.toStringAsFixed(0) ?? '0'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (status == 'shipped')
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.location_on, size: 18),
                label: const Text('Track Order'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accentGreen),
                  foregroundColor: AppColors.accentGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(String status) {
    final steps = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = steps.indexOf(status);

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.accentGreen : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent ? AppColors.accentGreen : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index].toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: isCompleted ? AppColors.accentGreen : AppColors.textGrey,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: index < currentIndex ? AppColors.accentGreen : Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return AppColors.accentGreen;
      case 'cancelled':
        return AppColors.errorRed;
      default:
        return Colors.grey;
    }
  }
}
