import 'package:financial_app/core/extensions/money_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditLimitCard extends StatefulWidget {
  const CreditLimitCard({super.key});

  @override
  State<CreditLimitCard> createState() => _CreditLimitCardState();
}

class _CreditLimitCardState extends State<CreditLimitCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLimitRow(
                  'Limite total',
                  transactionViewModel.creditCardModels!.creditCardLimit.toReal(),
                  AppColors.black,
                ),
                _buildLimitRow(
                  'Disponível',
                  transactionViewModel.creditCardModels!.creditCardAvailable.toReal(),
                  AppColors.green,
                ),
                _buildLimitRow(
                  'Utilizado',
                  transactionViewModel.creditCardModels!.creditCardUsed.toReal(),
                  AppColors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLimitRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: AppColors.blackText)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
