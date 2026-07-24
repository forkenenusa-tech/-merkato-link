import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class ProductGrid extends ConsumerStatefulWidget {
  const ProductGrid({super.key});

  @override
  ConsumerState<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<ProductGrid> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await ApiService.getProducts();
      if (response.statusCode == 200) {
        setState(() {
          _products = response.data['products'] ?? [];
        });
      }
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products available'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final badges = ['Choice', 'Sponsored', 'Local Store'];
    final badge = badges[product.hashCode.abs() % badges.length];
    final reviewCount = (product.hashCode.abs() % 500) + 50;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 115,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.lightGreen, AppColors.accentGreen.withOpacity(0.1)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: product['images'] != null && product['images'].isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product['images'][0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentGreen),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.shopping_bag,
                              color: AppColors.accentGreen.withOpacity(0.4),
                              size: 36,
                            ),
                          )
                        : Icon(
                            Icons.shopping_bag,
                            color: AppColors.accentGreen.withOpacity(0.4),
                            size: 36,
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badge == 'Sponsored' ? AppColors.gold : AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: (badge == 'Sponsored' ? AppColors.gold : AppColors.accentGreen).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: badge == 'Sponsored' ? AppColors.textDark : Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite_border, color: AppColors.textGrey, size: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Product',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 13),
                      const SizedBox(width: 3),
                      Text(
                        '${product['rating']?.toStringAsFixed(1) ?? '4.6'} ($reviewCount)',
                        style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Birr ${product['price']?.toStringAsFixed(0) ?? '23,999'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      if (product['discount'] != null && product['discount'] > 0)
                        Text(
                          ' -${product['discount']}%',
                          style: const TextStyle(fontSize: 11, color: AppColors.errorRed, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 11, color: AppColors.textGrey),
                      const SizedBox(width: 3),
                      Text(
                        product['location'] ?? 'Addis Ababa',
                        style: const TextStyle(fontSize: 9, color: AppColors.textGrey),
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
}