import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/home_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'bottom_sheet_recharge_phone_1.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          icon: Icon(PhosphorIcons.pixLogo(), size: 30, color: AppColors.white),
          label: 'Pix',
          onTap: () {
            HomeScreen.homeKey.currentState?.navigateToTab(3);
          },
        ),
        _QuickActionButton(
          icon: Icon(PhosphorIcons.barcode(), size: 30, color: AppColors.white),
          label: 'Pagar',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento em breve!')));
          },
        ),
        _QuickActionButton(
          icon: Icon(PhosphorIcons.deviceMobile(), size: 30, color: AppColors.white),
          label: 'Recarga',
          onTap: () {
            CustomBottomSheet.show(
                context,
                height: 390,
                iconClose: true,
                child: BottomSheetRechargePhone1());
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(30)),
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
