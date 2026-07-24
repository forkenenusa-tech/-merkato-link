import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class SellerProductsScreen extends ConsumerStatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  ConsumerState<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends ConsumerState<SellerProductsScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final response = await ApiService.getSellerProducts();
      if (response.statusCode == 200) {
        setState(() {
          _products = response.data['products'] ?? [];
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
          : Column(
              children: [
                _buildStatsRow(),
                Expanded(
                  child: _products.isEmpty
                      ? _buildEmptyState()
                      : _buildProductsList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        backgroundColor: AppColors.accentGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Total Products', _products.length.toString(), Icons.inventory_2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Active', '${_products.where((p) => p['status'] == 'active').length}', Icons.check_circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Out of Stock', '${_products.where((p) => p['stock'] == 0).length}', Icons.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accentGreen, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No products yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first product to start selling',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: product['images'] != null && product['images'].isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.shopping_bag, color: AppColors.accentGreen);
                      },
                    ),
                  )
                : const Icon(Icons.shopping_bag, color: AppColors.accentGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Product',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Birr ${product['price']?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: product['status'] == 'active' ? AppColors.accentGreen : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['status'] ?? 'active',
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Stock: ${product['stock'] ?? 0}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _showEditProductDialog(product),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.errorRed),
            onPressed: () => _deleteProduct(product['id']),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => _ProductDialog(onSave: _addProduct),
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => _ProductDialog(
        product: product,
        onSave: (data) => _updateProduct(product['id'], data),
      ),
    );
  }

  Future<void> _addProduct(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.createProduct(data);
      if (response.statusCode == 201) {
        _loadProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Future<void> _updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.updateProduct(id, data);
      if (response.statusCode == 200) {
        _loadProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await ApiService.deleteProduct(id);
        if (response.statusCode == 200) {
          _loadProducts();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product deleted successfully')),
            );
          }
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      }
    }
  }
}

class _ProductDialog extends StatefulWidget {
  final Map<String, dynamic>? product;
  final Function(Map<String, dynamic>) onSave;

  const _ProductDialog({this.product, required this.onSave});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? '';
      _priceController.text = widget.product!['price']?.toString() ?? '';
      _stockController.text = widget.product!['stock']?.toString() ?? '';
      _descriptionController.text = widget.product!['description'] ?? '';
      _categoryController.text = widget.product!['category'] ?? '';
      _status = widget.product!['status'] ?? 'active';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (Birr)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave({
                'name': _nameController.text,
                'price': double.parse(_priceController.text),
                'stock': int.parse(_stockController.text),
                'category': _categoryController.text,
                'description': _descriptionController.text,
                'status': _status,
              });
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
