import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _assignedCars = [];
  bool _isLoading = true;
  int _selectedOrderIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // For now, use mock data until backend endpoints are ready
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (mounted) {
        setState(() {
          // Mock orders data
          _orders = [
            {
              'id': 'ORD001',
              'totalAmount': 124.99,
              'itemCount': 3,
              'status': 'on_the_way',
              'createdAt': '2024-07-28T10:30:00Z',
              'estimatedDelivery': 'Today, 2:30 PM',
              'items': [
                {'name': 'Premium Coffee Beans', 'quantity': 2, 'price': 24.99},
                {'name': 'Organic Honey', 'quantity': 1, 'price': 15.99},
                {'name': 'Ethiopian Teff Flour', 'quantity': 1, 'price': 59.02},
              ],
            },
            {
              'id': 'ORD002',
              'totalAmount': 89.50,
              'itemCount': 2,
              'status': 'delivered',
              'createdAt': '2024-07-27T14:45:00Z',
              'estimatedDelivery': 'Delivered Jul 27',
              'items': [
                {'name': 'Fresh Vegetables Pack', 'quantity': 1, 'price': 34.50},
                {'name': 'Artisanal Bread', 'quantity': 3, 'price': 55.00},
              ],
            },
            {
              'id': 'ORD003',
              'totalAmount': 42.25,
              'itemCount': 1,
              'status': 'processing',
              'createdAt': '2024-07-28T11:15:00Z',
              'estimatedDelivery': 'Tomorrow, 10:00 AM',
              'items': [
                {'name': 'Natural Olive Oil', 'quantity': 2, 'price': 21.125},
              ],
            },
          ];
          
          // Mock assigned cars data
          _assignedCars = [
            {
              'id': 'CAR001',
              'orderId': 'ORD001',
              'model': 'Toyota Corolla',
              'color': 'White',
              'plateNumber': '3ABC123',
              'driverName': 'Abebe Kebede',
              'driverRating': 4.7,
              'estimatedArrival': '30-45 min',
              'distance': '5.2 km',
              'status': 'on_the_way',
            },
          ];
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    final orderId = order['id'] ?? '#0000';
    final totalAmount = order['totalAmount'] ?? 0;
    final itemCount = order['itemCount'] ?? 0;
    final status = order['status'] ?? 'pending';
    final createdAt = order['createdAt'] ?? '';
    final estimatedDelivery = order['estimatedDelivery'] ?? '';
    final isSelected = _selectedOrderIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedOrderIndex = index);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreen.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accentGreen : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order $orderId',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor(status)),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: AppColors.accentGreen),
                  const SizedBox(width: 8),
                  Text('$itemCount items', style: const TextStyle(color: AppColors.textGrey)),
                  const Spacer(),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
              if (estimatedDelivery.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.accentGreen),
                    const SizedBox(width: 8),
                    Text(
                      'Est. Delivery: $estimatedDelivery',
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car) {
    final carId = car['id'] ?? '#000';
    final carModel = car['model'] ?? 'Delivery Vehicle';
    final carColor = car['color'] ?? 'White';
    final carPlate = car['plateNumber'] ?? 'ABC123';
    final driverName = car['driverName'] ?? 'Driver';
    final driverRating = car['driverRating'] ?? 4.5;
    final estimatedArrival = car['estimatedArrival'] ?? '30-45 min';
    final distance = car['distance'] ?? '5.2 km';
    final status = car['status'] ?? 'on_the_way';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accentGreen),
                  ),
                  child: Text(
                    'ASSIGNED CAR',
                    style: TextStyle(
                      color: AppColors.accentGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'ID: $carId',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Car Information
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 32,
                    color: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carModel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _getCarColor(carColor),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$carColor • $carPlate',
                            style: const TextStyle(color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Driver Information
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.lightGreen,
                  child: Text(
                    driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            driverRating.toStringAsFixed(1),
                            style: const TextStyle(color: AppColors.textGrey),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.verified, size: 16, color: AppColors.accentGreen),
                          const SizedBox(width: 4),
                          const Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Delivery Information
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Arrival',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estimatedArrival,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getStatusText(status),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Live Tracking Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Open live tracking
                },
                icon: const Icon(Icons.location_on, size: 20),
                label: const Text(
                  'Live Tracking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.successGreen;
      case 'processing':
      case 'on_the_way':
        return AppColors.warningYellow;
      case 'shipped':
      case 'arriving':
        return AppColors.accentGreen;
      case 'delivered':
        return AppColors.successGreen;
      default:
        return AppColors.errorRed;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'processing':
        return Icons.schedule;
      case 'shipped':
        return Icons.local_shipping;
      case 'on_the_way':
        return Icons.directions_car;
      case 'arriving':
        return Icons.near_me;
      case 'delivered':
        return Icons.check_circle;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.pending;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'processing':
        return 'Order Processing';
      case 'shipped':
        return 'Order Shipped';
      case 'on_the_way':
        return 'On The Way';
      case 'arriving':
        return 'Arriving Soon';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Order Completed';
      default:
        return 'Pending';
    }
  }

  Color _getCarColor(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey[400]!;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return AppColors.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.accentGreen),
              const SizedBox(height: 20),
              const Text('Loading your orders...'),
            ],
          ),
        ),
      );
    }

    final hasOrders = _orders.isNotEmpty;
    final selectedOrder = hasOrders ? _orders[_selectedOrderIndex] : null;
    final assignedCarForOrder = hasOrders && _assignedCars.isNotEmpty 
        ? _assignedCars.where((car) => car['orderId'] == selectedOrder?['id']).firstOrNull 
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Order Tracking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -8, end: -8),
            badgeContent: Text('${_orders.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accentGreen),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag, color: AppColors.textDark),
              onPressed: () {},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textDark),
            onPressed: _loadData,
          ),
        ],
      ),
      body: hasOrders
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Orders Carousel
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _orders.length,
                      onPageChanged: (index) => setState(() => _selectedOrderIndex = index),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: _buildOrderCard(_orders[index], index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _orders.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppColors.accentGreen,
                        dotColor: Color(0xFFE0E0E0),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selected Order Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (selectedOrder != null) ...[
                          _buildOrderDetailsCard(selectedOrder),
                          const SizedBox(height: 24),
                        ],

                        // Assigned Car Section
                        if (assignedCarForOrder != null) ...[
                          const Text(
                            'Delivery Vehicle',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildCarCard(assignedCarForOrder),
                        ] else if (hasOrders) ...[
                          const Text(
                            'Delivery Vehicle',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.timer, size: 48, color: AppColors.accentGreen.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                const Text(
                                  'Vehicle Assignment Pending',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'A delivery vehicle will be assigned soon. You will be notified when a driver accepts your order.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'No Orders Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your orders will appear here when you make purchases',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start Shopping',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderDetailsCard(Map<String, dynamic> order) {
    final orderId = order['id'] ?? '#0000';
    final totalAmount = order['totalAmount'] ?? 0;
    final itemCount = order['itemCount'] ?? 0;
    final status = order['status'] ?? 'pending';
    final createdAt = order['createdAt'] ?? '';
    final estimatedDelivery = order['estimatedDelivery'] ?? '';
    final items = order['items'] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildOrderItems(items),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (estimatedDelivery.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.accentGreen),
                  const SizedBox(width: 8),
                  const Text(
                    'Estimated Delivery:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    estimatedDelivery,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrderItems(List<dynamic> items) {
    if (items.isEmpty) {
      return [
        const ListTile(
          leading: Icon(Icons.shopping_bag, color: AppColors.accentGreen),
          title: Text('No items found'),
        ),
      ];
    }

    return items.map<Widget>((item) {
      final name = item['name'] ?? 'Product';
      final quantity = item['quantity'] ?? 1;
      final price = item['price'] ?? 0;
      final total = price * quantity;

      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreen,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'P',
            style: const TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          'Quantity: $quantity',
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
        trailing: Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.accentGreen,
          ),
        ),
      );
    }).toList();
  }
}