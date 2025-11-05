import 'package:flutter/material.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/home_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          icon: Icons.pix,
          label: 'Pix',
          onTap: () {
            HomeScreen.homeKey.currentState?.navigateToTab(3);
          },
        ),
        _QuickActionButton(
          icon: Icons.payment,
          label: 'Pagar',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento em breve!')));
          },
        ),
        _QuickActionButton(
          icon: Icons.phone_android,
          label: 'Recarga',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recarga em breve!')));
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
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
            child: Icon(icon, color: AppColors.white, size: 28),
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
