import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Transações')),
      body: transactionProvider.transactions.isEmpty
          ? Center(child: Text('Nenhuma transação encontrada.'))
          : ListView.builder(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionProvider.transactions[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo: ${transaction.typeLabel}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Valor: R\$${transaction.amount.toStringAsFixed(2)}'),
                        Text('Data: ${transaction.date.toLocal().toString().split(' ')[0]}'),
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
}
