import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/screens/auth/login_screen.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:confetti/confetti.dart';

class DriverDashboardScreen extends ConsumerStatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  ConsumerState<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends ConsumerState<DriverDashboardScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late ConfettiController _confettiController;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _assignedDeliveries = [];
  List<Map<String, dynamic>> _availableDeliveries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await ApiService.getUserData();
      
      // Get driver stats from API
      final statsResponse = await ApiService.get('/api/driver/stats');
      final deliveriesResponse = await ApiService.get('/api/driver/deliveries');
      
      if (mounted) {
        setState(() {
          _userData = userData;
          
          // Parse stats from API response
          if (statsResponse.statusCode == 200) {
            final stats = statsResponse.data;
            _userData = {
              ...?userData,
              'totalEarnings': stats['weeklyEarnings'] ?? 0,
              'rating': stats['averageRating'] ?? 4.5,
            };
          }
          
          // Parse deliveries from API response
          if (deliveriesResponse.statusCode == 200) {
            final deliveries = deliveriesResponse.data['deliveries'] ?? [];
            _assignedDeliveries = deliveries.map((delivery) {
              final order = delivery['orderId'] ?? {};
              final customer = order['customerId'] ?? {};
              
              return {
                'id': delivery['_id'] ?? '',
                'customerName': customer['name'] ?? 'Customer',
                'amount': delivery['price'] ?? 0,
                'distance': '${delivery['distance'] ?? 0} km',
                'pickupTime': 'ASAP',
                'address': order['deliveryAddress'] ?? 'No address',
                'status': delivery['status'] ?? 'pending',
              };
            }).toList();
          }
          
          // For available deliveries, we'll use a separate API or mock for now
          // In a real app, you would have an endpoint for available deliveries
          _availableDeliveries = []; // Empty for now - needs separate endpoint
          
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Fallback to mock data if API fails
        _userData = {'name': 'Demo Driver', 'totalEarnings': 1245.75, 'rating': 4.8};
        _assignedDeliveries = [
          {
            'id': 'DLV001',
            'customerName': 'Demo Customer',
            'amount': 24.99,
            'distance': '3.2 km',
            'pickupTime': '10:30 AM',
            'address': '123 Demo St, Addis Ababa',
            'status': 'accepted',
          },
        ];
        _availableDeliveries = [
          {
            'id': 'DLV003',
            'customerName': 'Michael Brown',
            'amount': 32.75,
            'distance': '2.1 km',
            'pickupTime': 'ASAP',
            'address': '789 Churchill Rd, Addis Ababa',
            'status': 'pending',
          },
        ];
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using demo data. API Error: ${error.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
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

  void _acceptDelivery(Map<String, dynamic> delivery) {
    // In a real app, you would call an API to accept the delivery
    setState(() {
      _availableDeliveries.removeWhere((d) => d['id'] == delivery['id']);
      _assignedDeliveries.insert(0, {
        ...delivery,
        'status': 'accepted',
        'acceptedAt': DateTime.now().toIso8601String(),
      });
    });
    _confettiController.play();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted delivery #${delivery['id']}'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  void _markAsDelivered(Map<String, dynamic> delivery) {
    setState(() {
      _assignedDeliveries = _assignedDeliveries.map((d) {
        if (d['id'] == delivery['id']) {
          return {...d, 'status': 'delivered'};
        }
        return d;
      }).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked delivery #${delivery['id']} as delivered'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> delivery, bool isAssigned) {
    final status = delivery['status'] ?? 'pending';
    final amount = delivery['amount'] ?? 0;
    final distance = delivery['distance'] ?? '0 km';
    final pickupTime = delivery['pickupTime'] ?? 'ASAP';
    final customerName = delivery['customerName'] ?? 'Customer';
    final address = delivery['address'] ?? 'No address';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    color: status == 'delivered' 
                      ? AppColors.successGreen 
                      : status == 'accepted'
                        ? AppColors.accentGreen
                        : AppColors.warningYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Delivery to $customerName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppColors.accentGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.directions_car, size: 16, color: AppColors.accentGreen),
                const SizedBox(width: 8),
                Text('Distance: $distance', style: const TextStyle(color: AppColors.textGrey)),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: AppColors.accentGreen),
                const SizedBox(width: 8),
                Text('Pickup: $pickupTime', style: const TextStyle(color: AppColors.textGrey)),
              ],
            ),
            const SizedBox(height: 16),
            if (!isAssigned)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _acceptDelivery(delivery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Accept Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (isAssigned && status == 'accepted')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _markAsDelivered(delivery),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentGreen,
                    side: const BorderSide(color: AppColors.accentGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Mark as Delivered',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                badges.Badge(
                  badgeContent: Text('+3', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accentGreen),
                  child: const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
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
              const Text('Loading your dashboard...'),
            ],
          ),
        ),
      );
    }

    final name = _userData?['name'] ?? 'Driver';
    final earnings = _userData?['totalEarnings'] ?? 0;
    final completedDeliveries = _assignedDeliveries.where((d) => d['status'] == 'delivered').length;
    final rating = _userData?['rating'] ?? 4.5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textDark),
            onPressed: () {},
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -8, end: -8),
            badgeContent: Text('${_availableDeliveries.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.errorRed),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.textDark),
              onPressed: () {},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Confetti controller
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [AppColors.accentGreen, AppColors.primaryGreen, Colors.blue],
            ),

            // Stats section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatsCard('Total Earnings', '\$${earnings.toStringAsFixed(2)}', Icons.monetization_on, AppColors.successGreen),
                  const SizedBox(width: 12),
                  _buildStatsCard('Deliveries', '$completedDeliveries', Icons.delivery_dining, AppColors.accentGreen),
                  const SizedBox(width: 12),
                  _buildStatsCard('Rating', rating.toStringAsFixed(1), Icons.star, AppColors.warningYellow),
                ],
              ),
            ),

            // Carousel for available deliveries
            if (_availableDeliveries.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: const Text(
                      'Available Deliveries',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _availableDeliveries.length,
                      itemBuilder: (context, index) {
                        return _buildDeliveryCard(_availableDeliveries[index], false);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _availableDeliveries.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppColors.accentGreen,
                        dotColor: Color(0xFFE0E0E0),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Assigned deliveries
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Deliveries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  badges.Badge(
                    badgeContent: Text('${_assignedDeliveries.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                    badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accentGreen),
                    child: const SizedBox(),
                  ),
                ],
              ),
            ),

            // Assigned deliveries list
            if (_assignedDeliveries.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.delivery_dining, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'No deliveries assigned yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Accept available deliveries to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _assignedDeliveries
                    .map((delivery) => _buildDeliveryCard(delivery, true))
                    .toList(),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Refresh data
          _loadData();
        },
        backgroundColor: AppColors.accentGreen,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text('Refresh', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}