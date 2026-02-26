import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  String? _selectedBusinessType;
  bool _isLoading = false;

  final List<Map<String, String>> _businessTypes = [
    {'value': 'physical', 'label': 'Physical retail location', 'title': 'Shop'},
    {'value': 'Online', 'label': 'E-commerce or social media', 'title': 'Online Seller'},
    {'value': 'Hybrid(online & physical)', 'label': 'Multi-channel business', 'title': 'Both Online & Physical'},
    {'value': 'open market', 'label': 'Market stall or outdoor vendor', 'title': 'Open Market'},
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _businessNameController.text.isEmpty ||
        _selectedBusinessType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call backend API to save business details
      final res = await ApiService.post('/v1/business', 
        body: {
          'fullName': _fullNameController.text.trim(),
          'phoneNumber': _phoneNumberController.text.trim(),
          'businessName': _businessNameController.text.trim(),
          'businessType': _selectedBusinessType,
        },
        auth: true,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Business setup complete!')),
      );
      Navigator.pushReplacementNamed(context, '/products-intro');
    } catch (e) {
      if (!mounted) return;
      final msg = e is Exception ? e.toString().replaceFirst('ApiException: ', '') : 'Error: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Tell us about your business', style: GoogleFonts.inter(color: AppColors.textDark)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text('Full name', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Your full name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Phone number', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+234 800 000 0000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Business name', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  hintText: 'e.g. John\'s Store',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Shop type', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(
                'This helps LedgerLy give you insights that match your shop type.',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _businessTypes.length,
                itemBuilder: (ctx, idx) {
                  final type = _businessTypes[idx];
                  final isSelected = _selectedBusinessType == type['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedBusinessType = type['value']),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primaryTeal : AppColors.borderGrey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? AppColors.primaryTeal.withOpacity(0.05) : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              type['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primaryTeal : AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              type['label']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              LedgerlyButton(
                label: 'Continue',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
