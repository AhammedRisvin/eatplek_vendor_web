// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/profile/model/get_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/top_bar.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../view_model/profile_provider.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  static const int _kTabIndex = 9;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.watch<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProfileProvider>().getVendorProfileFn(context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: Consumer<ProfileProvider>(
            builder: (context, p, _) {
              if (p.isVendorLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (p.isVendorError || p.getVendorModel?.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load profile',
                        style: GoogleFonts.urbanist(
                          color: AppColor.black60,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => p.getVendorProfileFn(context: context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkBlue,
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.urbanist(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final vendor = p.getVendorModel!.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Profile header ──────────────────────────────────
                    _SectionCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Profile',
                                style: GoogleFonts.urbanist(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Restaurant image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 220,
                                  height: 160,
                                  child:
                                      vendor.restaurantImage != null &&
                                          vendor.restaurantImage!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: vendor.restaurantImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: const Color(0xFFF3F4F6),
                                          child: const Icon(
                                            Icons.restaurant,
                                            size: 48,
                                            color: Color(0xFFD1D5DB),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Commission badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F6FA),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${vendor.commissionRate ?? 0}%',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Text(
                                            'Commission',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 11,
                                              color: AppColor.black60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: navigate to edit profile
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.darkBlue,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Edit Profile',
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Personal info
                                Text(
                                  'Personal Information',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _InfoPair('Name', vendor.ownerName ?? '--'),
                                    const SizedBox(width: 32),
                                    _InfoPair(
                                      'Phone Number',
                                      '+${vendor.dialCode ?? ''} ${vendor.phone ?? vendor.phoneNumber ?? '--'}',
                                    ),
                                    const SizedBox(width: 32),
                                    _InfoPair('Email ID', vendor.email ?? '--'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Restaurant Information ────────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant Information',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _InfoPair(
                                'Restaurant Name',
                                vendor.restaurantName ?? '--',
                              ),
                              const SizedBox(width: 32),
                              _InfoPair(
                                'Service Offered',
                                vendor.serviceOffered?.join(', ') ?? '--',
                              ),
                              const SizedBox(width: 32),
                              _InfoPair(
                                'FSSAI License Number',
                                vendor.fssaiLicenseNumber ?? '--',
                              ),
                              const SizedBox(width: 32),
                              _InfoPair('GST Number', vendor.gstNumber ?? '--'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Location Details ──────────────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location Details',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Map placeholder
                              Container(
                                width: 140,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.map_outlined,
                                    size: 36,
                                    color: Color(0xFFD1D5DB),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Row(
                                  children: [
                                    _InfoPair(
                                      'Full Address',
                                      vendor.address?.fullAddress ?? '--',
                                    ),
                                    const SizedBox(width: 24),
                                    _InfoPair(
                                      'City',
                                      vendor.address?.city ?? '--',
                                    ),
                                    const SizedBox(width: 24),
                                    _InfoPair(
                                      'State',
                                      vendor.address?.state ?? '--',
                                    ),
                                    const SizedBox(width: 24),
                                    _InfoPair(
                                      'Pincode',
                                      vendor.address?.pincode ?? '--',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Operating Hours ───────────────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Operating Hours',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Header row
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Day',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black60,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Open Time',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black60,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Close Time',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black60,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Closed',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black60,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          ...(vendor.operatingHours ?? []).map((hour) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      hour.day ?? '',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          hour.isClosed == true
                                              ? '--'
                                              : p.formatTime(hour.openTime),
                                          style: GoogleFonts.urbanist(
                                            fontSize: 13,
                                            color: AppColor.black60,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: AppColor.black40,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          hour.isClosed == true
                                              ? '--'
                                              : p.formatTime(hour.closeTime),
                                          style: GoogleFonts.urbanist(
                                            fontSize: 13,
                                            color: AppColor.black60,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: AppColor.black40,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Switch(
                                      value: hour.isClosed == true,
                                      activeThumbColor: AppColor.darkBlue,
                                      onChanged: (val) {
                                        hour.isClosed = val;
                                        p.patchOperatingHoursFn(context);
                                        p.notifyListeners();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Delivery Preferences ──────────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Preferences',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _InfoPair(
                                'Do you offer delivery',
                                (vendor.serviceOffered?.contains('delivery') ??
                                        false)
                                    ? 'Yes'
                                    : 'No',
                              ),
                              const SizedBox(width: 40),
                              _InfoPair(
                                'Delivery Radius',
                                '${vendor.deliveryRadius ?? '--'} Km',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Bank & Payment Details ────────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Bank & Payment Details',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.black,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  p._clearBankFields();
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        const _AddBankAccountDialog(),
                                  );
                                },
                                child: Text(
                                  'Add Bank Account',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: AppColor.darkBlue,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          if (vendor.bankAccounts == null ||
                              vendor.bankAccounts!.isEmpty)
                            Text(
                              'No bank accounts added yet',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: AppColor.black60,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: vendor.bankAccounts!
                                  .map((bank) => _BankCard(bank: bank))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }
}

// ─── Info pair ────────────────────────────────────────────────────────────────
class _InfoPair extends StatelessWidget {
  final String label;
  final String value;
  const _InfoPair(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 11,
            color: AppColor.black60,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }
}

// ─── Bank card ────────────────────────────────────────────────────────────────
class _BankCard extends StatelessWidget {
  final BankAccount bank;
  const _BankCard({required this.bank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Bank logo placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(
              Icons.account_balance,
              size: 20,
              color: AppColor.darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank.bankName ?? '--',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                Text(
                  bank.accountHolderName ?? '--',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    color: AppColor.black60,
                  ),
                ),
                if (bank.isActive == true)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Primary',
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        color: const Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: view full bank details
            },
            child: Text(
              'View Details',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: AppColor.darkBlue,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add Bank Account Dialog ──────────────────────────────────────────────────
class _AddBankAccountDialog extends StatelessWidget {
  const _AddBankAccountDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(28),
        child: Consumer<ProfileProvider>(
          builder: (context, p, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Bank Account',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Account holder + Bank name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Account Holder Name'),
                          const SizedBox(height: 8),
                          _StyledTextField(
                            controller: p.accountHolderController,
                            hint: 'Enter Name',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Bank Name'),
                          const SizedBox(height: 8),
                          _StyledTextField(
                            controller: p.bankNameController,
                            hint: 'Enter Name',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Account number + Confirm
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Account Number'),
                          const SizedBox(height: 8),
                          _StyledTextField(
                            controller: p.accountNumberController,
                            hint: 'Rs',
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
                          const _FieldLabel('Confirm Account Number'),
                          const SizedBox(height: 8),
                          _StyledTextField(
                            controller: p.confirmAccountNumberController,
                            hint: 'Rs',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // IFSC
                const _FieldLabel('IFSC Code'),
                const SizedBox(height: 8),
                SizedBox(
                  width: 220,
                  child: _StyledTextField(
                    controller: p.ifscController,
                    hint: 'Rs',
                  ),
                ),
                const SizedBox(height: 16),

                // Make as Primary toggle
                Row(
                  children: [
                    Checkbox(
                      value: p.makeAsPrimary,
                      activeColor: AppColor.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) => p.setMakeAsPrimary(val ?? false),
                    ),
                    Text(
                      'Make as Primary',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Add button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: p.isAddingBank
                        ? null
                        : () => p.addBankAccountFn(context: context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkBlue,
                      disabledBackgroundColor: AppColor.darkBlue.withOpacity(
                        0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: p.isAddingBank
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Add Account',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Reusable ─────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

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

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
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

// Extension to call private method from dialog (needed for clearBankFields)
extension _ProfileProviderExt on ProfileProvider {
  void _clearBankFields() {
    accountHolderController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    confirmAccountNumberController.clear();
    ifscController.clear();
    makeAsPrimary = false;
    notifyListeners();
  }
}
