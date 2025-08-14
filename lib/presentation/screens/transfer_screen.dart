import 'package:financial_app/core/extensions/account_input_formatter_ext.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _toAccountTextEditingController = TextEditingController();
  final TextEditingController _amountTextEditingController = TextEditingController();
  final FocusNode _toAccountFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _toAccountTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _toAccountFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionVM = context.read<TransactionViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Para quem você quer transferir?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _toAccountTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Conta de Destino',
                  hintText: 'ex: 12345-9',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [AccountInputFormatterExt()],
                validator: transactionVM.validateToAccount,
                focusNode: _toAccountFocusNode,
              ),
              SizedBox(height: 22),
              TextFormField(
                controller: _amountTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  hintText: 'R\$ 0,00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, BRLCurrencyInputFormatterExt()],
                validator: transactionVM.validateAmount,
                focusNode: _amountFocusNode,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Text(
                    "Saldo:",
                    style: TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Consumer<AccountViewModel>(
                    builder: (context, accountViewModel, child) {
                      return Text(
                        accountViewModel.displayBalance,
                        style: const TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Consumer2<AccountViewModel, TransactionViewModel>(
                builder: (context, accountViewModel, transactionViewModel, child) {
                  return accountViewModel.isLoading || transactionViewModel.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              /*CustomBottomSheet.show(
                                  context,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        color: Colors.red,
                                        child: Center(child: Text("Container 1")),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 100,
                                        color: Colors.blue,
                                        child: Center(child: Text("Container 2")),
                                      ),
                                    ],
                                  ),
                                );
                              },*/
                              transactionVM.showErrors = true;
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                              if (authViewModel.currentUser == null || accountViewModel.account == null) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(const SnackBar(content: Text('Usuário ou conta não logados.')));
                                return;
                              }

                              final double amount = BRLCurrencyInputFormatterExt.parse(
                                _amountTextEditingController.text,
                              );
                              final String toAccount = _toAccountTextEditingController.text;

                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final bool successWithdrawal = await transactionViewModel.transferBetweenAccounts(
                                toAccount,
                                amount,
                              );

                              if (successWithdrawal) {
                                _amountTextEditingController.clear();
                                _toAccountTextEditingController.clear();
                                _toAccountFocusNode.unfocus();
                                _amountFocusNode.unfocus();

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Transferência realizada com sucesso!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      transactionViewModel.errorMessage ?? 'Erro na transferência',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            },
                            child: const Text('Transferir'),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
