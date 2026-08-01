import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/screens/customer/product_detail_screen.dart';
import 'package:merkato_mobile/screens/customer/cart_screen.dart';
import 'package:merkato_mobile/screens/customer/search_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreenEnhanced extends ConsumerStatefulWidget {
  const HomeScreenEnhanced({super.key});

  @override
  ConsumerState<HomeScreenEnhanced> createState() => _HomeScreenEnhancedState();
}

class _HomeScreenEnhancedState extends ConsumerState<HomeScreenEnhanced> {
  final CarouselController _carouselController = CarouselController();
  int _currentCarouselIndex = 0;
  List<dynamic> _featuredProducts = [];
  List<dynamic> _categories = [];
  List<dynamic> _recentProducts = [];
  Map<String, dynamic>? _userData;
  int _cartCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load user data
      final userData = await ApiService.getUserData();
      
      // Load products
      final productsResponse = await ApiService.getProducts();
      final products = productsResponse.data['products'] ?? [];
      
      // Load cart count
      final cartResponse = await ApiService.getCart();
      final cartItems = cartResponse.data['items'] ?? [];
      
      // Get categories
      final categorySet = <String>{};
      for (var product in products) {
        if (product['category'] != null && product['category'].isNotEmpty) {
          categorySet.add(product['category']);
        }
      }
      
      setState(() {
        _userData = userData;
        _featuredProducts = products.where((p) => p['isFeatured'] == true).take(5).toList();
        _recentProducts = products.take(10).toList();
        _categories = categorySet.toList();
        _cartCount = cartItems.length;
        _isLoading = false;
      });
    } catch (error) {
      // Fallback to sample data
      setState(() {
        _featuredProducts = [
          {
            'id': '1',
            'name': 'Organic Avocado',
            'price': 89.99,
            'category': 'Fruits',
            'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578',
            'rating': 4.8,
            'description': 'Fresh organic avocado from local farms',
            'stock': 25,
          },
          {
            'id': '2',
            'name': 'Premium Coffee Beans',
            'price': 249.99,
            'category': 'Beverages',
            'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
            'rating': 4.9,
            'description': 'Freshly roasted premium coffee beans',
            'stock': 18,
          },
          {
            'id': '3',
            'name': 'Artisanal Honey',
            'price': 149.99,
            'category': 'Condiments',
            'image': 'https://images.unsplash.com/photo-1587049352851-8d4e89133924',
            'rating': 4.7,
            'description': 'Pure natural honey from local beekeepers',
            'stock': 30,
          },
        ];
        _categories = ['Fruits', 'Vegetables', 'Beverages', 'Dairy', 'Bakery'];
        _recentProducts = [
          {
            'id': '4',
            'name': 'Fresh Milk',
            'price': 45.99,
            'category': 'Dairy',
            'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b',
            'rating': 4.5,
            'description': 'Fresh pasteurized milk',
            'stock': 50,
          },
          {
            'id': '5',
            'name': 'Whole Wheat Bread',
            'price': 35.99,
            'category': 'Bakery',
            'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
            'rating': 4.6,
            'description': 'Fresh whole wheat bread',
            'stock': 40,
          },
        ];
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingShimmer() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Categories shimmer
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Products shimmer
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.lightGreen,
                child: product['image'] != null
                    ? Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 40),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 40),
                      ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['category'] ?? 'Category',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['name'] ?? 'Product',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        (product['rating'] ?? 4.0).toStringAsFixed(1),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if ((product['stock'] ?? 0) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'In Stock',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Birr ${(product['price'] ?? 0).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: AppColors.accentGreen,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.grass;
      case 'beverages':
        return Icons.coffee;
      case 'dairy':
        return Icons.egg;
      case 'bakery':
        return Icons.bakery_dining;
      default:
        return Icons.category;
    }
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      await ApiService.addToCart({
        'productId': product['id'],
        'quantity': 1,
      });
      
      setState(() => _cartCount++);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} added to cart'),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _userData?['name'] ?? 'Customer';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: _isLoading
          ? _buildLoadingShimmer()
          : CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 0, bottom: 16),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          badges.Badge(
                            position: badges.BadgePosition.topEnd(top: -8, end: -8),
                            badgeContent: Text('$_cartCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                            badgeStyle: const badges.BadgeStyle(badgeColor: Color(0xFFEF4444)),
                            showBadge: _cartCount > 0,
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textDark),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                ).then((_) => _loadData());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.textGrey),
                            const SizedBox(width: 12),
                            Text(
                              'Search for products...',
                              style: TextStyle(
                                color: AppColors.textGrey,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.filter_list, color: AppColors.textGrey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Carousel Banner
                if (_featuredProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 160,
                            aspectRatio: 16/9,
                            viewportFraction: 0.85,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() => _currentCarouselIndex = index);
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: _featuredProducts.map((product) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(product: product),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: product['image'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(product['image']),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: AppColors.lightGreen,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ?? 'Product',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Birr ${(product['price'] ?? 0).toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _featuredProducts.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _carouselController.animateToPage(entry.key),
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentCarouselIndex == entry.key
                                      ? AppColors.accentGreen
                                      : Colors.grey[300],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                // Categories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return _buildCategoryCard(_categories[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Products
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View All',
                            style: TextStyle(color: AppColors.accentGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Products Grid
                _recentProducts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              const Text(
                                'No products available',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildProductCard(_recentProducts[index]),
                            childCount: _recentProducts.length,
                          ),
                        ),
                      ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            ),
      // Bottom Navigation
      bottomNavigationBar: Container(
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
                _buildNavItem(Icons.home_filled, 'Home', true),
                _buildNavItem(Icons.shopping_bag_outlined, 'Shop', false),
                _buildNavItem(Icons.favorite_border, 'Wishlist', false),
                _buildNavItem(Icons.person_outline, 'Profile', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? AppColors.accentGreen : AppColors.textGrey,
          size: 24,
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
    );
  }
}