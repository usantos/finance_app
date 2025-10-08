import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, accountViewModel, child) {
        return Card(
          color: AppColors.secondary,
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo disponível', style: TextStyle(color: AppColors.grey, fontSize: 16)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          accountViewModel.toggleVisibility();
                        });
                      },
                      child: Icon(
                        accountViewModel.isHidden ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  accountViewModel.displayBalance,
                  style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
