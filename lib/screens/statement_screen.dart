import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:intl/intl.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
      if (authViewModel.currentUser != null && accountViewModel.account != null) {
        Provider.of<TransactionViewModel>(context, listen: false).fetchTransactions(accountViewModel.account!.id);
      }
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        title: Text(
          'Extrato',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionViewModel, child) {
          if (transactionViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (transactionViewModel.errorMessage != null) {
            return Center(
              child: Text(
                'Erro: ${transactionViewModel.errorMessage}',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            );
          } else if (transactionViewModel.transactions.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma transação encontrada.',
                style: theme.textTheme.bodyMedium,
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: transactionViewModel.transactions.length,
              itemBuilder: (context, index) {
                final tx = transactionViewModel.transactions[index];
                final isDeposit = tx.type == 'deposit';
                final isWithdrawal = tx.type == 'withdrawal';
                final icon = isDeposit
                    ? Icons.arrow_downward
                    : isWithdrawal
                    ? Icons.arrow_upward
                    : Icons.compare_arrows;
                final iconColor = isDeposit ? Colors.green : Colors.red;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withOpacity(0.15),
                      child: Icon(icon, color: iconColor),
                    ),
                    title: Text(
                      tx.description,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      formatDate(tx.date.toLocal()),
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    trailing: Text(
                      'R\$ ${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
