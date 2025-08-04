import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
      appBar: AppBar(title: const Text('Histórico de Transações')),
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
                child: ListView.builder(
                  primary: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: transactionViewModel.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionViewModel.transactions[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo: ${transaction.typeLabel}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text('Valor: R\$${transaction.amount.toStringAsFixed(2)}'),
                            Text('Data: ${transaction.formattedDate}'),
                            Text('Descrição: ${transaction.description}'),
                            if (transaction.fromAccount != null) Text('De: ${transaction.fromAccount}'),
                            if (transaction.toAccount != null) Text('Para: ${transaction.toAccount}'),
                          ],
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
