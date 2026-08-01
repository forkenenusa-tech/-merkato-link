import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:merkato_mobile/screens/customer/checkout_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

class CartScreenEnhanced extends ConsumerStatefulWidget {
  const CartScreenEnhanced({super.key});

  @override
  ConsumerState<CartScreenEnhanced> createState() => _CartScreenEnhancedState();
}

class _CartScreenEnhancedState extends ConsumerState<CartScreenEnhanced> {
  List<dynamic> _cartItems = [];
  double _subtotal = 0.0;
  double _deliveryFee = 50.0;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.getCart();
      final cartData = response.data;
      
      final items = cartData['items'] ?? [];
      double subtotal = 0.0;
      
      for (var item in items) {
        final product = item['product'] ?? {};
        final quantity = item['quantity'] ?? 1;
        final price = product['price'] ?? 0.0;
        subtotal += price * quantity;
      }
      
      setState(() {
        _cartItems = items;
        _subtotal = subtotal;
        _isLoading = false;
      });
    } catch (error) {
      // Fallback to sample data
      setState(() {
        _cartItems = [
          {
            'id': 'cart1',
            'product': {
              'id': '1',
              'name': 'Organic Avocado',
              'price': 89.99,
              'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578',
              'stock': 25,
            },
            'quantity': 2,
          },
          {
            'id': 'cart2',
            'product': {
              'id': '2',
              'name': 'Premium Coffee Beans',
              'price': 249.99,
              'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
              'stock': 18,
            },
            'quantity': 1,
          },
        ];
        _subtotal = (89.99 * 2) + 249.99;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity < 1) {
      await _removeItem(cartItemId);
      return;
    }
    
    setState(() => _isUpdating = true);
    try {
      await ApiService.updateCartItem(cartItemId, newQuantity);
      await _loadCart();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quantity: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _removeItem(String cartItemId) async {
    try {
      await ApiService.removeFromCart(cartItemId);
      await _loadCart();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildLoadingShimmer() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (int i = 0; i < 3; i++)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 15,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final product = item['product'] ?? {};
    final quantity = item['quantity'] ?? 1;
    final price = product['price'] ?? 0.0;
    final itemTotal = price * quantity;
    final stock = product['stock'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: product['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.shopping_bag, color: AppColors.accentGreen),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(Icons.shopping_bag, color: AppColors.accentGreen),
                  ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Product',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Birr ${price.toStringAsFixed(0)} each',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Stock status
                if (stock <= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (stock < quantity)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Only $stock available',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 12),
                
                // Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _isUpdating ? null : () => _updateQuantity(item['id'], quantity - 1),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity <= 1 ? Colors.grey[400] : AppColors.accentGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _isUpdating || quantity >= (stock > 10 ? 10 : stock) 
                                ? null 
                                : () => _updateQuantity(item['id'], quantity + 1),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: quantity >= (stock > 10 ? 10 : stock) ? Colors.grey[400] : AppColors.accentGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Item total and remove button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Birr ${itemTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _isUpdating ? null : () => _removeItem(item['id']),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline, size: 12, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final total = _subtotal + _deliveryFee;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                const Text(
                  'My Shopping Cart',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                badges.Badge(
                  badgeContent: Text('${_cartItems.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accentGreen),
                  child: const Icon(Icons.shopping_cart, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          
          // Cart Items
          Expanded(
            child: _isLoading
                ? _buildLoadingShimmer()
                : _cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: AppColors.textGrey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add some products to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.shopping_bag),
                              label: const Text('Continue Shopping'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            ..._cartItems.map((item) => _buildCartItem(item)),
                            const SizedBox(height: 20),
                            
                            // Order Summary
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
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
                                  const Text(
                                    'Order Summary',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Subtotal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Subtotal',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      Text(
                                        'Birr ${_subtotal.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Delivery Fee
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Delivery Fee',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      Text(
                                        'Birr ${_deliveryFee.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const Divider(height: 24),
                                  
                                  // Total
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        'Birr ${total.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Delivery Estimate
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.local_shipping, size: 16, color: AppColors.accentGreen),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'Estimated delivery: 3-5 business days',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 80), // Spacer for bottom button
                          ],
                        ),
                      ),
          ),
          
          // Checkout Button
          if (_cartItems.isNotEmpty)
            Container(
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cartItems: _cartItems,
                          subtotal: _subtotal,
                          deliveryFee: _deliveryFee,
                          total: total,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock_outline, size: 20),
                  label: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}