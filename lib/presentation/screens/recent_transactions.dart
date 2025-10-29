import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'components/transaction_card.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  final List<Transaction> _transactions = [
    Transaction(
      name: 'João Silva',
      date: DateTime(2025, 10, 6),
      time: const TimeOfDay(hour: 14, minute: 30),
      amount: 150.00,
      type: TransactionType.debit,
      category: 'PIX',
    ),
    Transaction(
      name: 'Supermercado Extra',
      date: DateTime(2025, 10, 5),
      time: const TimeOfDay(hour: 19, minute: 45),
      amount: 185.50,
      type: TransactionType.debit,
      category: 'Compra',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return const Center(
        child: Text('Nenhuma transação encontrada.', style: TextStyle(color: AppColors.black)),
      );
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
