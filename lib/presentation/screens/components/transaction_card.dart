import 'package:financial_app/core/extensions/date_ext.dart';
import 'package:financial_app/core/extensions/time_ext.dart';
import 'package:flutter/material.dart';

enum TransactionType { credit, debit }

class Transaction {
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final double amount;
  final TransactionType type;
  final String category;

  Transaction({
    required this.description,
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

    final Color amountColor = transaction.type == TransactionType.credit ? Colors.green[700]! : Colors.red[700]!;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.description,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              '${transaction.date.formatDate()} • ${transaction.time.formatHour()}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5.0)),
                  child: Text(transaction.category, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
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
