import 'package:flutter/material.dart';
import 'components/transaction_card.dart';

class RecentPix extends StatefulWidget {
  const RecentPix({super.key});

  @override
  State<RecentPix> createState() => _RecentPixState();
}

class _RecentPixState extends State<RecentPix> {
  final List<Transaction> _transactions = [
    Transaction(
      description: 'Transferência PIX - João Silva',
      date: DateTime(2025, 10, 6),
      time: const TimeOfDay(hour: 14, minute: 30),
      amount: 150.00,
      type: TransactionType.debit,
      category: 'Transferência',
    ),
    Transaction(
      description: 'Transferência PIX - Felipe',
      date: DateTime(2025, 10, 5),
      time: const TimeOfDay(hour: 19, minute: 45),
      amount: 185.50,
      type: TransactionType.credit,
      category: 'Transferência',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return const Center(child: Text('Nenhuma transação encontrada.'));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return TransactionCard(transaction: _transactions[index]);
      },
    );
  }
}
