import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      if (authViewModel.currentUser != null) {
        Provider.of<AccountViewModel>(context, listen: false).fetchAccount(authViewModel.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saldo')),
      body: Consumer<AccountViewModel>(
        builder: (context, accountViewModel, child) {
          if (accountViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (accountViewModel.errorMessage != null) {
            return Center(child: Text('Erro: ${accountViewModel.errorMessage}'));
          } else if (accountViewModel.account == null) {
            return const Center(child: Text('Nenhuma conta encontrada.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo Atual:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    'R\$ ${accountViewModel.account!.balance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text('Número da Conta: ${accountViewModel.account!.accountNumber}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
