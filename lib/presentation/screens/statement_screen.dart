import 'package:financial_app/core/extensions/money_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final _authViewModel = sl.get<AuthViewModel>();
  final _accountViewModel = sl.get<AccountViewModel>();
  final _transactionViewModel = sl.get<TransactionViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authViewModel.currentUser != null && _accountViewModel.account != null) {
        _transactionViewModel.fetchTransactions(_accountViewModel.account!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Extrato',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Consumer<TransactionViewModel>(
          builder: (context, transactionViewModel, child) {
            if (transactionViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (transactionViewModel.errorMessage != null) {
              return Center(child: Text('Erro: ${transactionViewModel.errorMessage}'));
            } else if (transactionViewModel.transactions.isEmpty) {
              return const Center(child: Text('Nenhuma transação encontrada.'));
            } else {
              return Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  primary: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: transactionViewModel.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionViewModel.transactions[index];
                    final isDeposit = transaction.type == 'deposit';
                    final isWithdrawal = transaction.type == 'withdrawal';
                    final icon = isDeposit
                        ? Icons.arrow_downward
                        : isWithdrawal
                        ? Icons.arrow_upward
                        : Icons.compare_arrows;
                    final iconColor = isDeposit
                        ? Colors.green
                        : isWithdrawal
                        ? Colors.red
                        : Colors.blue;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Icon(icon, color: iconColor, size: 28),
                        title: Text(transaction.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(transaction.formattedDate),
                        trailing: Text(
                          transaction.amount.toReal(),
                          style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
