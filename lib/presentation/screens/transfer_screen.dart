import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:financial_app/core/extensions/account_input_formatter_ext.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
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
  final _transactionViewModel = sl.get<TransactionViewModel>();
  final _accountViewModel = sl.get<AccountViewModel>();

  @override
  void dispose() {
    _toAccountTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _toAccountFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkTransferPassword();
  }

  Future<void> _checkTransferPassword() async {
    await _transactionViewModel.verifyTransferPassword();

    if (!_transactionViewModel.hasPassword && context.mounted) {
      CustomBottomSheet.show(
        context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Para efetuar a transação é necessário cadastrar a senha de 4 dígitos.',
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(const BorderSide(color: Colors.black, width: 1)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Depois", style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: () {
                    PinBottomSheet.show(
                      context,
                      title: 'Escolha uma senha de 4 dígitos',
                      autoSubmitOnComplete: false,
                      onCompleted: (transferPassword) {
                        _transactionViewModel.setTransferPassword(transferPassword);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text("Cadastrar"),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountViewModel, TransactionViewModel>(
      builder: (context, accountViewModel, transactionViewModel, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Para quem você quer transferir?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
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
                      validator: _transactionViewModel.validateToAccount,
                      focusNode: _toAccountFocusNode,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _amountTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        hintText: 'R\$ 0,00',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, BRLCurrencyInputFormatterExt()],
                      validator: _transactionViewModel.validateAmount,
                      focusNode: _amountFocusNode,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        const Text(
                          "Saldo:",
                          style: TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          accountViewModel.displayBalance,
                          style: const TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    transactionViewModel.isLoading || accountViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: _transactionViewModel.hasPassword
                                  ? () async {
                                      _transactionViewModel.showErrors = true;
                                      if (!_formKey.currentState!.validate()) return;
                                      FocusScope.of(context).unfocus();

                                      PinBottomSheet.show(
                                        context,
                                        title: 'Insira sua senha de 4 dígitos',
                                        onCompleted: (pin) async {
                                          if (await _accountViewModel.getUser() == null ||
                                              _accountViewModel.account == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Usuário ou conta não encontrados.')),
                                            );
                                            return;
                                          }

                                          final double amount = BRLCurrencyInputFormatterExt.parse(
                                            _amountTextEditingController.text,
                                          );
                                          final String toAccount = _toAccountTextEditingController.text;

                                          final bool success = await _transactionViewModel.transferBetweenAccounts(
                                            toAccount,
                                            amount,
                                            pin,
                                          );

                                          if (success) {
                                            _amountTextEditingController.clear();
                                            _toAccountTextEditingController.clear();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text('Transferência realizada com sucesso!'),
                                                backgroundColor: Colors.green,
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  _transactionViewModel.errorMessage ?? 'Erro na transferência',
                                                ),
                                                backgroundColor: Colors.red,
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text('Transferir'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
