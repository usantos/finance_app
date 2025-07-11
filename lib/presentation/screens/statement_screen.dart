import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extrato')),
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionViewModel, child) {
          if (transactionViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (transactionViewModel.errorMessage != null) {
            return Center(child: Text('Erro: ${transactionViewModel.errorMessage}'));
          } else if (transactionViewModel.transactions.isEmpty) {
            return const Center(child: Text('Nenhuma transação encontrada.'));
          } else {
            return ListView.builder(
              itemCount: transactionViewModel.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionViewModel.transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      transaction.type == 'deposit'
                          ? Icons.arrow_downward
                          : transaction.type == 'withdrawal'
                          ? Icons.arrow_upward
                          : Icons.compare_arrows,
                      color: transaction.type == 'deposit' ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction.description),
                    subtitle: Text(transaction.date.toLocal().toString().split(' ')[0]),
                    trailing: Text(
                      'R\$ ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(color: transaction.type == 'deposit' ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
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
