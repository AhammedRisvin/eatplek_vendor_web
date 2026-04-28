// ignore_for_file: use_build_context_synchronously

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/top_bar.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../../widgets/common_table.dart';
import '../view_model/delivery_boy_provider.dart';

// ════════════════════════════════════════════════════════════════════════════
//  LISTING SCREEN
// ════════════════════════════════════════════════════════════════════════════

class DeliveryBoyView extends StatefulWidget {
  const DeliveryBoyView({super.key});

  @override
  State<DeliveryBoyView> createState() => _DeliveryBoyViewState();
}

class _DeliveryBoyViewState extends State<DeliveryBoyView> {
  static const int _kTabIndex = 6;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.read<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DeliveryBoyProvider>().getDeliveryBoysFn(context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Delivery Boys',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddDeliveryBoyView(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Delivery Boy',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter tabs + search
                Consumer<DeliveryBoyProvider>(
                  builder: (context, p, _) => Row(
                    children: [
                      _Tab(
                        label: 'All Delivery boys',
                        selected: p.filterTab == 'All Delivery boys',
                        onTap: () => p.setFilterTab('All Delivery boys'),
                      ),
                      const SizedBox(width: 8),
                      _Tab(
                        label: 'Payouts',
                        selected: p.filterTab == 'Payouts',
                        onTap: () => p.setFilterTab('Payouts'),
                      ),
                      const Spacer(),
                      _SearchBar(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const DeliveryTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColor.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColor.darkBlue : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColor.black60,
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 16, color: AppColor.black40),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
              decoration: InputDecoration(
                hintText: 'Search Delivery Boy',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.hintText,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _kDeliveryColumns = [
  AppTableColumn(label: 'Delivery Boy', flex: 3),
  AppTableColumn(label: 'Email', flex: 3),
  AppTableColumn(label: 'Phone Number', flex: 3),
  AppTableColumn(label: 'Status', flex: 2),
  AppTableColumn(label: 'Action', flex: 2),
];

class DeliveryTable extends StatelessWidget {
  const DeliveryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryBoyProvider>(
      builder: (context, p, _) {
        // Delivery boys list has no pagination from the API currently
        return AppDataTable(
          columns: _kDeliveryColumns,
          isLoading: p.isLoading,
          isEmpty: p.deliveryBoys.isEmpty,
          emptyMessage: 'No delivery boys added yet',
          rows: p.deliveryBoys.map((b) => _DeliveryRow(boy: b)).toList(),
          // No pagination prop → bar is hidden automatically
        );
      },
    );
  }
}

class _DeliveryRow extends StatelessWidget {
  final Map<String, dynamic> boy;
  const _DeliveryRow({required this.boy});

  @override
  Widget build(BuildContext context) {
    final isActive = boy['isActive'] == true;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.darkBlue.withOpacity(0.1),
                  child: Text(
                    (boy['name'] ?? 'D')[0].toUpperCase(),
                    style: GoogleFonts.urbanist(
                      color: AppColor.darkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  boy['name'] ?? '',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              boy['email'] ?? '',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              boy['phone'] ?? '',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFEF4444),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 20, color: AppColor.darkBlue),
                SizedBox(width: 16),
                Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ADD DELIVERY BOY SCREEN
// ════════════════════════════════════════════════════════════════════════════

class AddDeliveryBoyView extends StatelessWidget {
  const AddDeliveryBoyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _AddTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Consumer<DeliveryBoyProvider>(
                builder: (context, p, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Delivery Boys',
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Image + Name & Email
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          GestureDetector(
                            onTap: () => _pickImage(context, p),
                            child: Container(
                              width: 200,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: p.imageUrlForUpload.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: Image.network(
                                        p.imageUrlForUpload,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: const BoxDecoration(
                                            color: AppColor.darkBlue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Add image',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        Text(
                                          'add your image for Profile',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 11,
                                            color: AppColor.black60,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Full Name'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.fullNameController,
                                  hint: 'Enter full name',
                                ),
                                const SizedBox(height: 16),
                                const _FL('Email'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.emailController,
                                  hint: 'Enter email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Phone + Location
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Phone Number'),
                                const SizedBox(height: 8),
                                _PhoneField(p: p),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Location'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.locationController,
                                  hint: 'Select location',
                                  suffix: const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: AppColor.darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Passwords
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Create Password'),
                                const SizedBox(height: 8),
                                _PwField(
                                  controller: p.passwordController,
                                  hint: 'Enter password',
                                  show: p.showPassword,
                                  onToggle: p.togglePassword,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Confirm Password'),
                                const SizedBox(height: 8),
                                _PwField(
                                  controller: p.confirmPasswordController,
                                  hint: 'Enter Password',
                                  show: p.showConfirmPassword,
                                  onToggle: p.toggleConfirmPassword,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Bank Account
                      Text(
                        'Add Bank Account',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Account Holder Name'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.accountHolderController,
                                  hint: 'Enter holder name',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Bank Name'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.bankNameController,
                                  hint: 'Enter bank name',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Account Number'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.accountNumberController,
                                  hint: 'Enter account number',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _FL('Confirm Account Number'),
                                const SizedBox(height: 8),
                                _TF(
                                  controller: p.confirmAccountNumberController,
                                  hint: 'Enter account number',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FL('IFSC Code'),
                            const SizedBox(height: 8),
                            _TF(
                              controller: p.ifscController,
                              hint: 'Enter IFSC Code',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: p.isAdding
                            ? null
                            : () => p.addDeliveryBoyFn(context: context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkBlue,
                          disabledBackgroundColor: AppColor.darkBlue
                              .withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: p.isAdding
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Add Delivery Boy',
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, DeliveryBoyProvider p) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
        withData: true,
      );
      if (result == null) return;
      final file = result.files.first;
      if (file.bytes == null) return;
      p.pickImageFromGalleryWeb(context, file.bytes!, file.name);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }
}

class _AddTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 17
        ? 'Good Afternoon,'
        : 'Good Evening,';
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColor.darkBlue,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
              Text(
                AppPref.userName,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.black60,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            AppPref.userName,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.darkBlue.withOpacity(0.12),
            child: Text(
              AppPref.userName.isNotEmpty
                  ? AppPref.userName[0].toUpperCase()
                  : 'V',
              style: GoogleFonts.urbanist(
                color: AppColor.darkBlue,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────
class _FL extends StatelessWidget {
  final String text;
  const _FL(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColor.black,
    ),
  );
}

class _TF extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final Widget? suffix;

  const _TF({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColor.hintText),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.darkBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _PwField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;

  const _PwField({
    required this.controller,
    required this.hint,
    required this.show,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !show,
      style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColor.hintText),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18,
            color: AppColor.black40,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.darkBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final DeliveryBoyProvider p;
  const _PhoneField({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  p.dialCode,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 18,
                  color: AppColor.black40,
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: p.phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColor.hintText,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
