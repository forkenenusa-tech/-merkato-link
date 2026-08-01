import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/screens/home_screen.dart';
import 'package:merkato_mobile/screens/seller/seller_dashboard_enhanced_v2.dart';
import 'package:merkato_mobile/screens/driver/driver_dashboard_screen.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreenEnhanced extends ConsumerStatefulWidget {
  const RegisterScreenEnhanced({super.key});

  @override
  ConsumerState<RegisterScreenEnhanced> createState() => _RegisterScreenEnhancedState();
}

class _RegisterScreenEnhancedState extends ConsumerState<RegisterScreenEnhanced> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _selectedRole = 'customer';
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<String> _roles = ['customer', 'seller', 'driver'];
  final List<IconData> _roleIcons = [Icons.shopping_bag, Icons.store, Icons.local_shipping];
  final List<String> _roleTitles = ['Customer', 'Seller', 'Driver'];
  final List<String> _roleDescriptions = [
    'Shop for products and enjoy delivery services',
    'Sell your products and grow your business',
    'Deliver orders and earn money flexibly'
  ];
  final List<Color> _roleColors = [
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.register({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'role': _selectedRole,
      });

      if (response.statusCode == 201) {
        final data = response.data;
        await ApiService.saveToken(data['token']);
        await ApiService.saveUserData(data);

        if (mounted) {
          final role = data['role'] ?? 'customer';
          
          if (role == 'seller') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SellerDashboardEnhancedV2()),
            );
          } else if (role == 'driver') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DriverDashboardScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
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

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 8,
            width: index == _currentStep ? 32 : 8,
            decoration: BoxDecoration(
              color: index == _currentStep ? AppColors.accentGreen : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRoleCard(int index) {
    final isSelected = _roles[index] == _selectedRole;
    final role = _roles[index];
    final icon = _roleIcons[index];
    final title = _roleTitles[index];
    final description = _roleDescriptions[index];
    final color = _roleColors[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool isPassword = false,
    bool? showPassword,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !(showPassword ?? false),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textGrey),
          prefixIcon: Icon(prefixIcon, color: AppColors.accentGreen),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    (showPassword ?? false) ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.accentGreen,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us about yourself to get started',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 32),
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleSelectionStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Choose Your Role',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select how you want to use Merkato Link',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 32),
        ...List.generate(_roles.length, (index) => _buildRoleCard(index)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.accentGreen, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Role Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Customers can shop and place orders\n'
                '• Sellers can list products and manage inventory\n'
                '• Drivers can accept and deliver orders\n'
                '• You can switch roles anytime from your profile',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Account Security',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create a strong password to protect your account',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 32),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          prefixIcon: Icons.lock,
          isPassword: true,
          showPassword: _showPassword,
          onTogglePassword: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          showPassword: _showConfirmPassword,
          onTogglePassword: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Password Requirements',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• At least 6 characters\n'
                '• Mix of letters and numbers\n'
                '• Avoid common passwords\n'
                '• Keep your password secure',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Back button and progress
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                    ),
                    const Spacer(),
                    _buildStepIndicator(),
                    const Spacer(),
                    const SizedBox(width: 48), // For balance
                  ],
                ),
                const SizedBox(height: 20),
                
                // PageView for steps
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPersonalInfoStep(),
                      _buildRoleSelectionStep(),
                      _buildSecurityStep(),
                    ],
                  ),
                ),
                
                // Navigation buttons
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _currentStep--);
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accentGreen,
                              side: const BorderSide(color: AppColors.accentGreen),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_currentStep < 2) {
                                    // Validate current step
                                    bool isValid = true;
                                    if (_currentStep == 0) {
                                      if (_nameController.text.isEmpty ||
                                          _emailController.text.isEmpty ||
                                          _phoneController.text.isEmpty) {
                                        isValid = false;
                                      }
                                    } else if (_currentStep == 1) {
                                      if (_selectedRole.isEmpty) {
                                        isValid = false;
                                      }
                                    }
                                    
                                    if (isValid) {
                                      setState(() => _currentStep++);
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please fill all required fields'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    // Final step - submit registration
                                    _register();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Text(
                                  _currentStep < 2 ? 'Continue' : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Terms and conditions
                const Text.rich(
                  TextSpan(
                    text: 'By creating an account, you agree to our ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}