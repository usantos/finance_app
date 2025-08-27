import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:financial_app/core/extensions/account_input_formatter_ext.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/components/custom_bottom_sheet.dart';

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
  late TransactionViewModel _transactionVM;
  late AuthViewModel _authViewModel;
  late AccountViewModel _accountViewModel;

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
    _authViewModel = context.read<AuthViewModel>();
    _accountViewModel = context.read<AccountViewModel>();
    _transactionVM = context.read<TransactionViewModel>();
    _checkTransferPassword();
  }

  Future<void> _checkTransferPassword() async {
    _transactionVM = context.read<TransactionViewModel>();
    await _transactionVM.verifyTransferPassword();

    if (!_transactionVM.hasPassword && context.mounted) {
      CustomBottomSheet.show(
        context,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Para efetuar a transação é necessario cadastrar a senha de 4 digitos.',
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(BorderSide(color: Colors.black, width: 1)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Depois", style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 20),
                FilledButton(
                  onPressed: () {
                    PinBottomSheet.show(
                      context,
                      title: 'Escolha uma senha de 4 dígitos',
                      autoSubmitOnComplete: false,
                      onCompleted: (transferPassword) {
                        _transactionVM.setTransferPassword(transferPassword);
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
    final transactionVM = context.read<TransactionViewModel>();

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
                  validator: transactionVM.validateToAccount,
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
                  validator: transactionVM.validateAmount,
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
                const SizedBox(height: 40),
                Consumer2<AccountViewModel, TransactionViewModel>(
                  builder: (context, accountViewModel, transactionViewModel, child) {
                    return accountViewModel.isLoading || transactionViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: transactionVM.hasPassword
                                  ? () async {
                                      transactionVM.showErrors = true;
                                      if (!_formKey.currentState!.validate()) return;
                                      FocusScope.of(context).unfocus();
                                      PinBottomSheet.show(
                                        context,
                                        title: 'Insira sua senha de 4 dígitos',
                                        onCompleted: (pin) async {
                                          if (_authViewModel.currentUser == null || _accountViewModel.account == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Usuário ou conta não logados.')),
                                            );
                                            return;
                                          }

                                          final double amount = BRLCurrencyInputFormatterExt.parse(
                                            _amountTextEditingController.text,
                                          );
                                          final String toAccount = _toAccountTextEditingController.text;

                                          final bool success = await transactionVM.transferBetweenAccounts(
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
                                                content: Text(transactionVM.errorMessage ?? 'Erro na transferência'),
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
