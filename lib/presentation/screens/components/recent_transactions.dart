import 'package:flutter/material.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final List<Map<String, dynamic>> transactions = [
    {'title': 'Transferência PIX', 'subtitle': 'Hoje', 'value': 'R\$ 150,00', 'color': Colors.red},
    {'title': 'Depósito', 'subtitle': 'Ontem', 'value': '+R\$ 1.200,00', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < transactions.length; i++) ...[
          _buildTransactionItem(
            transactions[i]['title'] as String,
            transactions[i]['subtitle'] as String,
            transactions[i]['value'] as String,
            transactions[i]['color'] as Color,
          ),
          if (i < transactions.length - 1) const Divider(height: 24),
        ],
      ],
    );
  }

  Widget _buildTransactionItem(String title, String subtitle, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Text(
          value,
          style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}