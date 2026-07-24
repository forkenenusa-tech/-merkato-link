import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  List<dynamic> _cartItems = [];
  double _total = 0;
  bool _isLoading = false;
  String _selectedPaymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final response = await ApiService.getCart();
      if (response.statusCode == 200) {
        setState(() {
          _cartItems = response.data['items'] ?? [];
          _total = response.data['total']?.toDouble() ?? 0.0;
        });
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.createOrder({
        'items': _cartItems,
        'total': _total + 50,
        'deliveryAddress': _addressController.text,
        'phone': _phoneController.text,
        'notes': _notesController.text,
        'paymentMethod': _selectedPaymentMethod,
      });

      if (response.statusCode == 201) {
        await ApiService.clearCart();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/order-success');
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeliveryAddress(),
              const SizedBox(height: 24),
              _buildPaymentMethod(),
              const SizedBox(height: 24),
              _buildOrderSummary(),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your delivery address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your delivery address';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Delivery notes (optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption('cash', 'Cash on Delivery', Icons.money),
        const SizedBox(height: 8),
        _buildPaymentOption('telebirr', 'Telebirr', Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentOption('bank', 'Bank Transfer', Icons.account_balance),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lightGreen : Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.accentGreen : AppColors.borderGrey,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        title: Row(
          children: [
            Icon(icon, color: AppColors.accentGreen),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
        activeColor: AppColors.accentGreen,
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            children: [
              ...List.generate(_cartItems.length, (index) {
                final item = _cartItems[index];
                final product = item['product'] ?? {};
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        '${item['quantity']}x ',
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                      Expanded(
                        child: Text(
                          product['name'] ?? 'Product',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Birr ${((product['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                  Text('Birr ${_total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery Fee', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                  const Text('Birr 50', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    'Birr ${(_total + 50).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
