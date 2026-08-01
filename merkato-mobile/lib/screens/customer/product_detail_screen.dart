import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;
  
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final CarouselController _carouselController = CarouselController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isAddingToCart = false;
  bool _isLoading = false;
  List<dynamic> _similarProducts = [];
  Map<String, dynamic>? _sellerInfo;

  @override
  void initState() {
    super.initState();
    _loadAdditionalData();
  }

  Future<void> _loadAdditionalData() async {
    try {
      // Load similar products
      final productsResponse = await ApiService.getProducts();
      final products = productsResponse.data['products'] ?? [];
      
      // Get products from same category
      final similar = products.where((p) => 
        p['category'] == widget.product['category'] && 
        p['id'] != widget.product['id']
      ).take(4).toList();
      
      // Load seller info if available
      if (widget.product['sellerId'] != null) {
        try {
          final sellerResponse = await ApiService.get('/api/users/${widget.product['sellerId']}');
          if (sellerResponse.statusCode == 200) {
            _sellerInfo = sellerResponse.data;
          }
        } catch (_) {
          // Seller info is optional
        }
      }
      
      setState(() {
        _similarProducts = similar;
      });
    } catch (error) {
      // Fallback to sample similar products
      setState(() {
        _similarProducts = [
          {
            'id': '6',
            'name': 'Organic Bananas',
            'price': 39.99,
            'category': widget.product['category'],
            'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e',
            'rating': 4.6,
            'description': 'Fresh organic bananas',
            'stock': 30,
          },
          {
            'id': '7',
            'name': 'Fresh Oranges',
            'price': 59.99,
            'category': widget.product['category'],
            'image': 'https://images.unsplash.com/photo-1547514701-42782101795e',
            'rating': 4.7,
            'description': 'Juicy fresh oranges',
            'stock': 25,
          },
        ];
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() => _isAddingToCart = true);
    
    try {
      await ApiService.addToCart({
        'productId': widget.product['id'],
        'quantity': _quantity,
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product['name']} added to cart'),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pop(context, true); // Return success
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isAddingToCart = false);
    }
  }

  Widget _buildDeliveryEstimate() {
    final deliveryDays = widget.product['deliveryDays'] ?? 3;
    final deliveryDate = DateTime.now().add(Duration(days: deliveryDays));
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping, color: AppColors.accentGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Estimate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Arrives by ${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
                Text(
                  '($deliveryDays business days)',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    if (_sellerInfo == null) return Container();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.store, color: AppColors.accentGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sellerInfo!['name'] ?? 'Seller',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _sellerInfo!['businessName'] ?? 'Verified Seller',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      (_sellerInfo!['rating'] ?? 4.5).toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    const Text(
                      'Verified',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(Map<String, dynamic> product) {
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
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: AppColors.lightGreen,
                child: product['image'] != null
                    ? Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 30),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 30),
                      ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Product',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Birr ${(product['price'] ?? 0).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 10, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        (product['rating'] ?? 4.0).toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
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

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product['images'] ?? [product['image']];
    final hasImages = images.isNotEmpty && images[0] != null;
    final price = product['price'] ?? 0;
    final totalPrice = price * _quantity;
    final stock = product['stock'] ?? 0;
    final isOutOfStock = stock == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Carousel
                  Stack(
                    children: [
                      if (hasImages)
                        CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 300,
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            onPageChanged: (index, reason) {
                              setState(() => _currentImageIndex = index);
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: images.map((image) {
                            return Container(
                              width: double.infinity,
                              color: AppColors.lightGreen,
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 80),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Container(
                          height: 300,
                          color: AppColors.lightGreen,
                          child: const Center(
                            child: Icon(Icons.shopping_bag, color: AppColors.accentGreen, size: 80),
                          ),
                        ),
                      
                      // Back button
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      
                      // Image indicator
                      if (hasImages && images.length > 1)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1}/${images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Product Info
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stock status
                        if (isOutOfStock)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 14, color: Colors.red),
                                const SizedBox(width: 6),
                                const Text(
                                  'Out of Stock',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  'In Stock: $stock available',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 12),
                        
                        // Product name and price
                        Text(
                          product['name'] ?? 'Product',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['category'] ?? 'Category',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Birr ${price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  (product['rating'] ?? 4.0).toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${product['reviewCount'] ?? 0})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Quantity Selector
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _quantity <= 1 ? Colors.grey[200] : AppColors.accentGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.remove, size: 18),
                                      color: _quantity <= 1 ? Colors.grey[400] : Colors.white,
                                      onPressed: _quantity <= 1
                                          ? null
                                          : () {
                                              setState(() => _quantity--);
                                            },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _quantity >= (stock > 10 ? 10 : stock) ? Colors.grey[200] : AppColors.accentGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.add, size: 18),
                                      color: _quantity >= (stock > 10 ? 10 : stock) ? Colors.grey[400] : Colors.white,
                                      onPressed: _quantity >= (stock > 10 ? 10 : stock) || isOutOfStock
                                          ? null
                                          : () {
                                              setState(() => _quantity++);
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['description'] ?? 'No description available.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textGrey,
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Delivery Estimate
                        _buildDeliveryEstimate(),
                        
                        const SizedBox(height: 20),
                        
                        // Seller Info
                        if (_sellerInfo != null) ...[
                          _buildSellerInfo(),
                          const SizedBox(height: 20),
                        ],
                        
                        // Similar Products
                        if (_similarProducts.isNotEmpty) ...[
                          const Text(
                            'Similar Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _similarProducts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index < _similarProducts.length - 1 ? 12 : 0,
                                  ),
                                  child: _buildSimilarProductCard(_similarProducts[index]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        
                        // Spacer for bottom buttons
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Action Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Total Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                          Text(
                            'Birr ${totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isOutOfStock || _isAddingToCart ? null : _addToCart,
                        icon: _isAddingToCart
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : const Icon(Icons.shopping_cart_outlined, size: 20),
                        label: Text(
                          isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOutOfStock ? Colors.grey : AppColors.accentGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}