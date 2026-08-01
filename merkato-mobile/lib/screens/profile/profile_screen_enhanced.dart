import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merkato_mobile/screens/auth/login_screen.dart';
import 'package:merkato_mobile/screens/customer/cart_screen.dart';
import 'package:merkato_mobile/screens/customer/wishlist_screen.dart';
import 'package:merkato_mobile/screens/customer/order_tracking_screen.dart';
import 'package:merkato_mobile/screens/seller/seller_dashboard_enhanced_v2.dart';
import 'package:merkato_mobile/screens/seller/seller_verification_screen.dart';
import 'package:merkato_mobile/screens/driver/driver_dashboard_screen.dart';
import 'package:merkato_mobile/screens/driver/driver_verification_screen.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/screens/profile/edit_profile_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:confetti/confetti.dart';

class ProfileScreenEnhanced extends ConsumerStatefulWidget {
  const ProfileScreenEnhanced({super.key});

  @override
  ConsumerState<ProfileScreenEnhanced> createState() => _ProfileScreenEnhancedState();
}

class _ProfileScreenEnhancedState extends ConsumerState<ProfileScreenEnhanced> {
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _statsData;
  bool _isLoading = true;
  String _activeRole = 'customer';
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _fetchProfile();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final localData = await ApiService.getUserData();
      final response = await ApiService.getProfile();
      if (response.statusCode == 200) {
        final profileData = response.data;
        await ApiService.saveUserData(profileData);
        
        // Try to fetch stats based on role
        try {
          if (profileData['role'] == 'seller') {
            final statsResponse = await ApiService.getSellerAnalytics();
            _statsData = statsResponse.data;
          } else if (profileData['role'] == 'driver') {
            final statsResponse = await ApiService.get('/api/driver/stats');
            _statsData = statsResponse.data;
          }
        } catch (_) {
          // Stats are optional
        }
        
        if (mounted) {
          setState(() {
            _userData = profileData;
            _activeRole = profileData['role'] ?? 'customer';
            _isLoading = false;
          });
        }
      } else if (localData != null) {
        if (mounted) {
          setState(() {
            _userData = localData;
            _activeRole = localData['role'] ?? 'customer';
            _isLoading = false;
          });
        }
      }
    } catch (_) {
      final localData = await ApiService.getUserData();
      if (mounted) {
        setState(() {
          _userData = localData;
          _activeRole = localData?['role'] ?? 'customer';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _switchRole(String targetRole) async {
    if (_userData == null) return;
    final currentRole = _userData!['role'];

    if (targetRole == currentRole) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are already in ${targetRole.toUpperCase()} mode'),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if target role requires verification
    if (targetRole == 'seller' && currentRole != 'seller') {
      _showRoleApplyDialog('Seller', const SellerVerificationScreen());
      return;
    } else if (targetRole == 'driver' && currentRole != 'driver') {
      _showRoleApplyDialog('Driver', const DriverVerificationScreen());
      return;
    }

    // Perform role switch
    try {
      final response = await ApiService.updateProfile({'role': targetRole});
      if (response.statusCode == 200) {
        await _fetchProfile();
        if (mounted) {
          _confettiController.play();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to ${targetRole.toUpperCase()} mode!'),
              backgroundColor: AppColors.accentGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not switch role: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showRoleApplyDialog(String roleName, Widget verificationScreen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  roleName == 'Seller' ? Icons.storefront : Icons.local_shipping,
                  color: AppColors.accentGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Become a $roleName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'To activate $roleName mode, you need to submit your business/license details for review.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textGrey,
                        side: const BorderSide(color: AppColors.borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => verificationScreen),
                        ).then((_) => _fetchProfile());
                      },
                      child: const Text('Complete Verification'),
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

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Confirm Logout'),
          ],
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ApiService.clearToken();
              await ApiService.clearUserData();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSwitchCard() {
    return Container(
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
            'Account Mode Switcher',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Switch between different account workspaces',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildRoleSwitchItem(
                'Customer',
                Icons.shopping_bag,
                const Color(0xFF3B82F6),
                'customer',
              ),
              const SizedBox(width: 12),
              _buildRoleSwitchItem(
                'Seller',
                Icons.store,
                const Color(0xFF10B981),
                'seller',
              ),
              const SizedBox(width: 12),
              _buildRoleSwitchItem(
                'Driver',
                Icons.local_shipping,
                const Color(0xFFF59E0B),
                'driver',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSwitchItem(String title, IconData icon, Color color, String role) {
    final isSelected = _activeRole == role;
    final isCurrent = _userData?['role'] == role;
    final isAvailable = isCurrent || 
                       (_userData?['approvedRoles']?.contains(role) ?? false) ||
                       _userData?['role'] == role;

    return Expanded(
      child: GestureDetector(
        onTap: isAvailable ? () => _switchRole(role) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ] : [],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAvailable ? color.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isAvailable ? color : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? AppColors.textDark : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              if (!isAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
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
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
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

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.accentGreen).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.accentGreen, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textGrey),
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
              const Text('Loading your profile...'),
            ],
          ),
        ),
      );
    }

    final name = _userData?['name'] ?? 'User';
    final email = _userData?['email'] ?? 'No email';
    final phone = _userData?['phone'] ?? 'No phone';
    final role = _userData?['role'] ?? 'customer';
    final profileImage = _userData?['profileImage'] ?? '';
    final isVerified = _userData?['isVerified'] ?? false;
    final address = _userData?['address'] ?? 'No address';
    final bio = _userData?['bio'] ?? '';

    // Stats based on role
    String statsValue1 = '';
    String statsTitle1 = '';
    IconData statsIcon1 = Icons.attach_money;
    Color statsColor1 = const Color(0xFF10B981);

    String statsValue2 = '';
    String statsTitle2 = '';
    IconData statsIcon2 = Icons.check_circle;
    Color statsColor2 = const Color(0xFF3B82F6);

    if (role == 'seller' && _statsData != null) {
      statsValue1 = 'Birr ${(_statsData!['totalRevenue'] ?? 0).toStringAsFixed(0)}';
      statsTitle1 = 'Total Revenue';
      statsValue2 = (_statsData!['activeProducts'] ?? 0).toString();
      statsTitle2 = 'Active Products';
      statsIcon2 = Icons.inventory_2;
    } else if (role == 'driver' && _statsData != null) {
      statsValue1 = 'Birr ${(_statsData!['weeklyEarnings'] ?? 0).toStringAsFixed(0)}';
      statsTitle1 = 'Weekly Earnings';
      statsValue2 = (_statsData!['totalDeliveries'] ?? 0).toString();
      statsTitle2 = 'Deliveries';
      statsIcon2 = Icons.local_shipping;
    } else {
      statsValue1 = '0';
      statsTitle1 = 'Total Orders';
      statsIcon1 = Icons.shopping_bag;
      statsValue2 = '0';
      statsTitle2 = 'Wishlist Items';
      statsIcon2 = Icons.favorite;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header with confetti
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0F382C), Color(0xFF1E5E4B), Color(0xFF2A7C64)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [AppColors.accentGreen, AppColors.primaryGreen, Colors.blue],
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Profile',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  badges.Badge(
                                    showBadge: !isVerified,
                                    badgeContent: const Icon(Icons.warning, size: 12, color: Colors.white),
                                    badgeStyle: const badges.BadgeStyle(badgeColor: Colors.orange),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit_note, color: Colors.white, size: 28),
                                      onPressed: () async {
                                        final updated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditProfileScreen(userData: _userData)),
                                        );
                                        if (updated == true) {
                                          await _fetchProfile();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundColor: Colors.white,
                                      backgroundImage: profileImage.isNotEmpty
                                          ? (profileImage.startsWith('http') || profileImage.startsWith('data:')
                                              ? NetworkImage(profileImage)
                                              : null)
                                          : null,
                                      child: profileImage.isEmpty
                                          ? Text(
                                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryGreen,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          email,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.85),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                role == 'seller'
                                                    ? Icons.store
                                                    : (role == 'driver' ? Icons.directions_car : Icons.person),
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                role.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (!isVerified) ...[
                                                const SizedBox(width: 6),
                                                const Icon(Icons.warning_amber, size: 12, color: Colors.orange),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Section
              if (statsValue1.isNotEmpty || statsValue2.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildStatsCard(statsTitle1, statsValue1, statsIcon1, statsColor1),
                        const SizedBox(width: 12),
                        _buildStatsCard(statsTitle2, statsValue2, statsIcon2, statsColor2),
                      ],
                    ),
                  ),
                ),

              // Role Switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRoleSwitchCard(),
                ),
              ),

              // Quick Actions based on role
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    role == 'seller' ? 'Seller Workspace' :
                    role == 'driver' ? 'Driver Dashboard' :
                    'Quick Actions',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: role == 'seller'
                      ? _buildDashboardAccessCard(
                          'Go to Seller Dashboard',
                          'Manage products, orders, and analytics',
                          Icons.dashboard,
                          const Color(0xFF10B981),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SellerDashboardEnhancedV2()),
                          ),
                        )
                      : role == 'driver'
                          ? _buildDashboardAccessCard(
                              'Go to Driver Dashboard',
                              'View deliveries, earnings, and routes',
                              Icons.dashboard,
                              const Color(0xFF3B82F6),
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DriverDashboardScreen()),
                              ),
                            )
                          : Container(
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
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildMiniActionCard(
                                          'Become a Seller',
                                          'Sell products online',
                                          Icons.storefront,
                                          const Color(0xFF059669),
                                          () => _showRoleApplyDialog('Seller', const SellerVerificationScreen()),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildMiniActionCard(
                                          'Become a Driver',
                                          'Deliver orders & earn',
                                          Icons.local_shipping,
                                          const Color(0xFF2563EB),
                                          () => _showRoleApplyDialog('Driver', const DriverVerificationScreen()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                ),
              ),

              // Profile Menu
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      children: [
                        _buildProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Personal Profile',
                          subtitle: 'Name, phone, avatar, and bio',
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfileScreen(userData: _userData)),
                            );
                            if (updated == true) await _fetchProfile();
                          },
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.shopping_cart_outlined,
                          title: 'My Shopping Cart',
                          subtitle: 'Items pending checkout',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.favorite_border,
                          title: 'My Wishlist',
                          subtitle: 'Saved favorite items',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WishlistScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.local_shipping_outlined,
                          title: 'Track Orders & Deliveries',
                          subtitle: 'Live order status updates',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.verified_user_outlined,
                          title: role == 'seller'
                              ? 'Seller License Details'
                              : (role == 'driver' ? 'Driver License Details' : 'Verification Applications'),
                          subtitle: 'Check registration and tax details',
                          onTap: () {
                            if (role == 'seller') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SellerVerificationScreen()),
                              );
                            } else if (role == 'driver') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DriverVerificationScreen()),
                              );
                            } else {
                              _showRoleApplyDialog('Seller', const SellerVerificationScreen());
                            }
                          },
                          iconColor: role == 'seller' 
                              ? const Color(0xFF10B981)
                              : role == 'driver'
                                ? const Color(0xFF3B82F6)
                                : AppColors.accentGreen,
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Customer Support & Help',
                          subtitle: '24/7 helpdesk and FAQ',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Support line: support@merkato.link'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          iconColor: Colors.orange,
                        ),
                        const Divider(height: 1, indent: 70),
                        _buildProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          subtitle: 'Sign out from your account',
                          onTap: _logout,
                          iconColor: Colors.red,
                          trailing: const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardAccessCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}