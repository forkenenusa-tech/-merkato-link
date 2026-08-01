import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/services/api_service.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

class SellerVerificationScreen extends ConsumerStatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  ConsumerState<SellerVerificationScreen> createState() => _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends ConsumerState<SellerVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _businessLicenseController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _yearsInBusinessController = TextEditingController();

  File? _businessLicenseImage;
  File? _taxCertificateImage;
  File? _businessRegistrationImage;
  File? _idFrontImage;
  File? _idBackImage;
  File? _businessPremisesImage;

  bool _isLoading = false;
  bool _isVerificationSubmitted = false;

  Future<void> _pickImage(ImageSource source, Function(File?) setImageFunction) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 75);
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

    if (_businessLicenseImage == null || _taxCertificateImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload business license and tax certificate images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final licenseBase64 = await _fileToBase64(_businessLicenseImage);
      final taxBase64 = await _fileToBase64(_taxCertificateImage);
      final regBase64 = await _fileToBase64(_businessRegistrationImage);
      final idFrontBase64 = await _fileToBase64(_idFrontImage);
      final idBackBase64 = await _fileToBase64(_idBackImage);
      final premisesBase64 = await _fileToBase64(_businessPremisesImage);

      final payload = {
        'businessName': _shopNameController.text.trim(),
        'businessLicense': _businessLicenseController.text.trim(),
        'taxId': _taxIdController.text.trim(),
        'businessAddress': _businessAddressController.text.trim(),
        'businessPhone': _businessPhoneController.text.trim(),
        'businessEmail': _businessEmailController.text.trim(),
        'yearsInBusiness': _yearsInBusinessController.text.trim(),
        'businessLicenseImage': licenseBase64,
        'taxCertificateImage': taxBase64,
        'businessRegistrationImage': regBase64,
        'idFrontImage': idFrontBase64,
        'idBackImage': idBackBase64,
        'businessPremisesImage': premisesBase64,
      };

      final response = await ApiService.post('/api/seller/apply', data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
          _isVerificationSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Business verification submitted successfully!'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to submit verification');
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
    bool isRequired,
    File? image,
    Function(File?) setImageFunction,
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
    _shopNameController.dispose();
    _businessLicenseController.dispose();
    _taxIdController.dispose();
    _businessAddressController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _yearsInBusinessController.dispose();
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
                  'Business Verification Submitted!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thank you for submitting your business verification documents. Our team will review them within 24-48 hours.',
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
          'Business Verification',
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
              // Header
              const Text(
                'Business Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete your business verification to start selling on Merkato Link',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 32),

              // Business Information
              const Text(
                '1. Business Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shopNameController,
                decoration: InputDecoration(
                  labelText: 'Business/Shop Name *',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _businessLicenseController,
                decoration: InputDecoration(
                  labelText: 'Business License Number *',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business license number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxIdController,
                decoration: InputDecoration(
                  labelText: 'Tax ID/Registration Number',
                  prefixIcon: const Icon(Icons.receipt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _businessAddressController,
                decoration: InputDecoration(
                  labelText: 'Business Address *',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _businessPhoneController,
                decoration: InputDecoration(
                  labelText: 'Business Phone *',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _businessEmailController,
                decoration: InputDecoration(
                  labelText: 'Business Email *',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearsInBusinessController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Years in Business',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Business Documents
              const Text(
                '2. Business Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildImageUpload(
                'Business License',
                'Clear image of your business license certificate',
                true,
                _businessLicenseImage,
                (file) => setState(() => _businessLicenseImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Tax Certificate',
                'Clear image of your tax registration certificate',
                true,
                _taxCertificateImage,
                (file) => setState(() => _taxCertificateImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Business Registration',
                'Business registration document (optional)',
                false,
                _businessRegistrationImage,
                (file) => setState(() => _businessRegistrationImage = file),
              ),
              const SizedBox(height: 32),

              // Identity Verification
              const Text(
                '3. Identity Verification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildImageUpload(
                'Government ID Front',
                'Clear image of the front side of your government ID',
                false,
                _idFrontImage,
                (file) => setState(() => _idFrontImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Government ID Back',
                'Clear image of the back side of your government ID',
                false,
                _idBackImage,
                (file) => setState(() => _idBackImage = file),
              ),
              const SizedBox(height: 24),
              _buildImageUpload(
                'Business Premises',
                'Image of your business premises (optional)',
                false,
                _businessPremisesImage,
                (file) => setState(() => _businessPremisesImage = file),
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
                          TextSpan(text: 'I confirm that all information provided is accurate and complete. I agree to the '),
                          TextSpan(
                            text: 'Merchant Agreement',
                            style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '.'),
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
                        Icon(Icons.security, color: AppColors.accentGreen, size: 20),
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
                      '• Approved sellers can start listing products immediately\n'
                      '• All documents are securely stored and encrypted\n'
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