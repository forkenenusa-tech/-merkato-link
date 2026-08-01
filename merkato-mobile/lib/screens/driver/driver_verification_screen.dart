import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DriverVerificationScreen extends ConsumerStatefulWidget {
  const DriverVerificationScreen({super.key});

  @override
  ConsumerState<DriverVerificationScreen> createState() => _DriverVerificationScreenState();
}

class _DriverVerificationScreenState extends ConsumerState<DriverVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
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
  File? _vehicleBackImage;
  File? _vehiclePlateImage;
  File? _insuranceImage;

  bool _isLoading = false;
  bool _isVerificationSubmitted = false;

  Future<void> _pickImage(ImageSource source, Function(File?) setImageFunction) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setImageFunction(File(pickedFile.path));
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
      final idBackBase64 = await _fileToBase64(_vehicleBackImage);

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

      // Call the real API endpoint
      final response = await ApiService.post('/api/driver/apply', data: verificationData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
          _isVerificationSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Driver application submitted successfully! Admin will review within 24-48 hours.'),
            backgroundColor: AppColors.accentGreen,
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
        ),
      );
    }
  }

  Widget _buildImageUpload(
    String title,
    String description,
    File? image,
    Function(File?) setImageFunction,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
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
              color: AppColors.lightGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: image != null ? AppColors.accentGreen : AppColors.textGrey.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: AppColors.accentGreen.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tap to upload',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Max 5MB',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
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
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.camera, setImageFunction),
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Retake'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setImageFunction(null),
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                label: const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ],
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isVerificationSubmitted) {
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
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 60,
                    color: AppColors.accentGreen,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Shimmer(
                duration: const Duration(seconds: 2),
                interval: const Duration(seconds: 3),
                color: Colors.white,
                colorOpacity: 0.5,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              const Text(
                'Complete Your Driver Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload required documents to start accepting deliveries',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 32),

              // License Information
              const Text(
                '1. Driver License',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licenseController,
                decoration: InputDecoration(
                  labelText: 'License Number',
                  prefixIcon: const Icon(Icons.card_membership),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                _licenseFrontImage,
                (file) => setState(() => _licenseFrontImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'License Back Side',
                'Clear image of the back side of your license',
                _licenseBackImage,
                (file) => setState(() => _licenseBackImage = file),
              ),
              const SizedBox(height: 32),

              // Vehicle Information
              const Text(
                '2. Vehicle Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleModelController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Model',
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehiclePlateController,
                decoration: InputDecoration(
                  labelText: 'License Plate Number',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter license plate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleColorController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Color',
                  prefixIcon: const Icon(Icons.color_lens),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                _vehicleFrontImage,
                (file) => setState(() => _vehicleFrontImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Vehicle Rear View',
                'Clear image showing the back of your vehicle',
                _vehicleBackImage,
                (file) => setState(() => _vehicleBackImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'License Plate',
                'Clear close-up of your license plate',
                _vehiclePlateImage,
                (file) => setState(() => _vehiclePlateImage = file),
              ),
              const SizedBox(height: 32),

              // Experience and Insurance
              const Text(
                '3. Additional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearsOfExperienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Years of Driving Experience',
                  prefixIcon: const Icon(Icons.timeline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter years of experience';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _insuranceProviderController,
                decoration: InputDecoration(
                  labelText: 'Insurance Provider',
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _insuranceNumberController,
                decoration: InputDecoration(
                  labelText: 'Insurance Policy Number',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Insurance Certificate',
                'Image of your insurance certificate (optional)',
                _insuranceImage,
                (file) => setState(() => _insuranceImage = file),
              ),
              const SizedBox(height: 32),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppColors.accentGreen,
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ', and confirm that all information provided is accurate.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Verification',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Information note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: AppColors.accentGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Verification Process',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Verification typically takes 24-48 hours\n'
                      '• You will receive email notification once approved\n'
                      '• Approved drivers can start accepting deliveries immediately\n'
                      '• Contact support@merkato.link for assistance',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}