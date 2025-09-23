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

class TransferCard extends StatefulWidget {
  const TransferCard({super.key});

  @override
  State<TransferCard> createState() => _TransferCardState();
}

class _TransferCardState extends State<TransferCard> {
  final _formKey = GlobalKey<FormState>();
  final _accountViewModel = sl.get<AccountViewModel>();
  final _transactionViewModel = sl.get<TransactionViewModel>();
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTransferPassword();
      FocusScope.of(context).unfocus();
    });

    super.initState();
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Enviar PIX', style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          accountViewModel.toggleVisibility();
                        });
                      },
                      child: Icon(accountViewModel.isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                    ),
                ],),
                const SizedBox(height: 35),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Chave PIX', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _toAccountTextEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 242, 242, 242),
                    enabledBorder: InputBorder.none,
                    hintText: 'CPF, e-mail, telefone ou chave aleatória',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [AccountInputFormatterExt()],
                  validator: _transactionViewModel.validateToAccount,
                  focusNode: _toAccountFocusNode,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Valor', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountTextEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 242, 242, 242),
                    enabledBorder: InputBorder.none,
                    hintText: 'R\$ 0,00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
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
                const SizedBox(height: 20),
                transactionViewModel.isLoading || accountViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          ),
                          onPressed:  _transactionViewModel.hasPassword
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
        );
      },
    );
  }
}
