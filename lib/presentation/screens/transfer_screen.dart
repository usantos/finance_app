import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transferência')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _toAccountController,
              decoration: const InputDecoration(labelText: 'Conta de Destino'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Consumer2<AccountViewModel, TransactionViewModel>(
              builder: (context, accountViewModel, transactionViewModel, child) {
                return accountViewModel.isLoading || transactionViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                          if (authViewModel.currentUser == null || accountViewModel.account == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário ou conta não logados.')));
                            return;
                          }

                          final double amount = double.parse(_amountController.text);
                          final String fromAccountId = accountViewModel.account!.id;
                          final String toAccount = _toAccountController.text;

                          final bool successWithdrawal = await accountViewModel.updateBalance(
                            fromAccountId,
                            accountViewModel.account!.balance - amount,
                          );

                          if (successWithdrawal) {
                            await transactionViewModel.addTransaction(
                              Transaction(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                accountId: fromAccountId,
                                type: 'withdrawal',
                                amount: amount,
                                date: DateTime.now(),
                                description: 'Transferência para $toAccount',
                                fromAccount: accountViewModel.account!.accountNumber,
                                toAccount: toAccount,
                              ),
                            );

                            if (toAccount == accountViewModel.account!.accountNumber) {
                              await transactionViewModel.addTransaction(
                                Transaction(
                                  id: '${DateTime.now().millisecondsSinceEpoch}_deposit',
                                  accountId: fromAccountId,
                                  type: 'deposit',
                                  amount: amount,
                                  date: DateTime.now(),
                                  description: 'Transferência recebida de ${accountViewModel.account!.accountNumber}',
                                  fromAccount: accountViewModel.account!.accountNumber,
                                  toAccount: toAccount,
                                ),
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Transferência realizada com sucesso!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  accountViewModel.errorMessage ?? 'Erro na transferência',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );

                          }
                        },
                        child: const Text('Transferir'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
