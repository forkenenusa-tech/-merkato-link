import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DriverVerificationEnhanced extends ConsumerStatefulWidget {
  const DriverVerificationEnhanced({super.key});

  @override
  ConsumerState<DriverVerificationEnhanced> createState() => _DriverVerificationEnhancedState();
}

class _DriverVerificationEnhancedState extends ConsumerState<DriverVerificationEnhanced> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final CarouselController _carouselController = CarouselController();
  
  final _licenseController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _insuranceProviderController = TextEditingController();
  final _insuranceNumberController = TextEditingController();

  File? _licenseFrontImage;
  File? _licenseBackImage;
  File? _vehicleFrontImage;
  File? _vehicleSideImage;
  File? _vehiclePlateImage;
  File? _insuranceImage;

  bool _isLoading = false;
  bool _isVerificationSubmitted = false;
  int _currentStep = 0;
  int _currentCarouselIndex = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Driver License',
      'subtitle': 'Upload your driver license details',
      'icon': Icons.card_membership,
      'color': const Color(0xFF3B82F6),
    },
    {
      'title': 'Vehicle Details',
      'subtitle': 'Provide your vehicle information',
      'icon': Icons.directions_car,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Additional Info',
      'subtitle': 'Experience and insurance details',
      'icon': Icons.info,
      'color': const Color(0xFFF59E0B),
    },
  ];

  Future<void> _pickImage(ImageSource source, Function(File?) setImageFunction) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        setImageFunction(File(pickedFile.path));
      });
    }
  }

  Future<String?> _fileToBase64(File? file) async {
    if (file == null) return null;
    try {
      final bytes = await file.readAsBytes();
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } catch (_) {
      return null;
    }
  }

  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate()) return;

    if (_licenseFrontImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your driver license image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final licenseImgBase64 = await _fileToBase64(_licenseFrontImage);
      final vehicleImgBase64 = await _fileToBase64(_vehicleFrontImage);
      final idFrontBase64 = await _fileToBase64(_licenseBackImage);
      final idBackBase64 = await _fileToBase64(_vehicleSideImage);

      final verificationData = {
        'licenseNumber': _licenseController.text.trim(),
        'vehicleType': 'car',
        'plateNumber': _vehiclePlateController.text.trim(),
        'vehicleModel': _vehicleModelController.text.trim(),
        'vehicleColor': _vehicleColorController.text.trim(),
        'yearsOfExperience': int.tryParse(_yearsOfExperienceController.text) ?? 0,
        'insuranceProvider': _insuranceProviderController.text.trim(),
        'insuranceNumber': _insuranceNumberController.text.trim(),
        'licenseImage': licenseImgBase64,
        'vehicleImage': vehicleImgBase64,
        'idFrontImage': idFrontBase64,
        'idBackImage': idBackBase64,
      };

      final response = await ApiService.post('/api/driver/apply', data: verificationData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
          _isVerificationSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Driver application submitted successfully!'),
            backgroundColor: AppColors.accentGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to submit driver application');
      }
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission Error: ${error.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildImageUpload(
    String title,
    String description,
    bool isRequired,
    File? image,
    Function(File?) setImageFunction,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickImage(ImageSource.gallery, setImageFunction),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: image != null ? color : AppColors.textGrey.withOpacity(0.3),
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
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: color.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to upload',
                        style: TextStyle(
                          fontSize: 16,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Max 5MB • JPG/PNG',
                        style: TextStyle(
                          fontSize: 12,
                          color: color.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (image != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera, setImageFunction),
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Retake'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.2),
                  foregroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => setImageFunction(null),
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Remove'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    Color? iconColor,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          labelStyle: const TextStyle(color: AppColors.textGrey),
          prefixIcon: Icon(prefixIcon, color: iconColor ?? AppColors.accentGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: iconColor ?? AppColors.accentGreen, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isCurrent = index == _currentStep;
        final isCompleted = index < _currentStep;
        
        return GestureDetector(
          onTap: () {
            if (index < _currentStep) {
              setState(() => _currentStep = index);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrent ? step['color'] : 
                           isCompleted ? step['color'] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isCurrent ? [
                      BoxShadow(
                        color: step['color'].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Icon(
                    step['icon'],
                    color: isCurrent || isCompleted ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step['title'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? step['color'] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildLicenseStep();
      case 1:
        return _buildVehicleStep();
      case 2:
        return _buildAdditionalInfoStep();
      default:
        return Container();
    }
  }

  Widget _buildLicenseStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver License Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload clear images of your valid driver license',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _licenseController,
            label: 'Driver License Number',
            prefixIcon: Icons.confirmation_number,
            iconColor: const Color(0xFF3B82F6),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter license number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'License Front Side',
            'Clear image of the front side of your license',
            true,
            _licenseFrontImage,
            (file) => setState(() => _licenseFrontImage = file),
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'License Back Side',
            'Clear image of the back side of your license',
            false,
            _licenseBackImage,
            (file) => setState(() => _licenseBackImage = file),
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildVehicleStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide details about your delivery vehicle',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _vehicleModelController,
            label: 'Vehicle Model',
            prefixIcon: Icons.directions_car,
            iconColor: const Color(0xFF10B981),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter vehicle model';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: _vehiclePlateController,
            label: 'License Plate Number',
            prefixIcon: Icons.confirmation_number,
            iconColor: const Color(0xFF10B981),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter license plate';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: _vehicleColorController,
            label: 'Vehicle Color',
            prefixIcon: Icons.color_lens,
            iconColor: const Color(0xFF10B981),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter vehicle color';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'Vehicle Front View',
            'Clear image showing the front of your vehicle',
            true,
            _vehicleFrontImage,
            (file) => setState(() => _vehicleFrontImage = file),
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'Vehicle Side View',
            'Clear image showing the side of your vehicle',
            false,
            _vehicleSideImage,
            (file) => setState(() => _vehicleSideImage = file),
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'License Plate Close-up',
            'Clear close-up of your license plate',
            false,
            _vehiclePlateImage,
            (file) => setState(() => _vehiclePlateImage = file),
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide experience and insurance details',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _yearsOfExperienceController,
            label: 'Years of Driving Experience',
            prefixIcon: Icons.timeline,
            iconColor: const Color(0xFFF59E0B),
            keyboardType: TextInputType.number,
            isRequired: false,
          ),
          _buildTextField(
            controller: _insuranceProviderController,
            label: 'Insurance Provider',
            prefixIcon: Icons.security,
            iconColor: const Color(0xFFF59E0B),
            isRequired: false,
          ),
          _buildTextField(
            controller: _insuranceNumberController,
            label: 'Insurance Policy Number',
            prefixIcon: Icons.confirmation_number,
            iconColor: const Color(0xFFF59E0B),
            isRequired: false,
          ),
          const SizedBox(height: 24),
          _buildImageUpload(
            'Insurance Certificate',
            'Image of your insurance certificate (optional)',
            false,
            _insuranceImage,
            (file) => setState(() => _insuranceImage = file),
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F382C), Color(0xFF1E5E4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Verification Submitted!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Thank you for submitting your verification documents. Our team will review them within 24-48 hours.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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
                    elevation: 4,
                  ),
                  child: const Text(
                    'Return to Dashboard',
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

  @override
  void dispose() {
    _licenseController.dispose();
    _vehicleModelController.dispose();
    _vehiclePlateController.dispose();
    _vehicleColorController.dispose();
    _yearsOfExperienceController.dispose();
    _insuranceProviderController.dispose();
    _insuranceNumberController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isVerificationSubmitted) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver Verification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildStepIndicator(),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStepContent(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _currentStep--);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accentGreen,
                          side: const BorderSide(color: AppColors.accentGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_currentStep < _steps.length - 1) {
                                setState(() => _currentStep++);
                              } else {
                                _submitVerification();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStep < _steps.length - 1
                            ? _steps[_currentStep + 1]['color']
                            : AppColors.accentGreen,
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
                              _currentStep < _steps.length - 1 ? 'Continue' : 'Submit Verification',
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
          ],
        ),
      ),
    );
  }
}