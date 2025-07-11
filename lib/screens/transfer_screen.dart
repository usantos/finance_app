import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';
import '../providers/auth_provider.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swap_horiz_rounded, size: 64, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Transferência',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: _toAccountController,
                  decoration: InputDecoration(
                    labelText: 'Conta de Destino',
                    prefixIcon: const Icon(Icons.account_circle),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),

                Consumer<AccountProvider>(
                  builder: (context, accountProvider, child) {
                    return accountProvider.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Transferir'),
                        onPressed: () async {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);

                          if (authProvider.user == null || accountProvider.account == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Usuário ou conta não logados.')),
                            );
                            return;
                          }

                          try {
                            final amount = double.parse(_amountController.text);

                            final success = await accountProvider.transferFunds(
                              accountProvider.account!.id,
                              _toAccountController.text,
                              amount,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Transferência realizada com sucesso!')),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(accountProvider.errorMessage ?? 'Erro na transferência')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Digite um valor válido.')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
