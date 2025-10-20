import 'package:financial_app/core/extensions/date_ext.dart';
import 'package:financial_app/core/extensions/time_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum TransactionType { credit, debit }

class Transaction {
  final String name;
  final String? description;
  final DateTime date;
  final TimeOfDay time;
  final double amount;
  final TransactionType type;
  final String category;

  Transaction({
    required this.name,
    this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.type,
    required this.category,
  });
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final String amountText = transaction.type == TransactionType.credit
        ? '+R\$ ${transaction.amount.toStringAsFixed(2).replaceAll('.', ',')}'
        : '-R\$ ${transaction.amount.toStringAsFixed(2).replaceAll('.', ',')}';

    final Color amountColor = transaction.type == TransactionType.credit ? AppColors.green : AppColors.red;

    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.black),
              overflow: TextOverflow.ellipsis,
            ),

            if (transaction.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 5),
              Text(
                transaction.description ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 5),
            Text(
              '${transaction.date.formatDate()} • ${transaction.time.formatHour()}',
              style: TextStyle(color: AppColors.blackText, fontSize: 13),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(color: AppColors.greyBackground, borderRadius: BorderRadius.circular(5.0)),
                  child: Text(transaction.category, style: TextStyle(color: AppColors.blackText, fontSize: 12)),
                ),
                Text(
                  amountText,
                  style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
