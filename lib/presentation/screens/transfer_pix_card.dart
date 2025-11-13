import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/services/transfer_password_service.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransferPixCard extends StatefulWidget {
  const TransferPixCard({super.key});

  @override
  State<TransferPixCard> createState() => _TransferPixCardState();
}

class _TransferPixCardState extends State<TransferPixCard> {
  final _formKey = GlobalKey<FormState>();
  final _transactionVM = sl.get<TransactionViewModel>();
  final TextEditingController _toKeyPixTextEditingController = TextEditingController();
  final TextEditingController _amountTextEditingController = TextEditingController();
  final FocusNode _toKeyPixFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _toKeyPixTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _toKeyPixFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTransferPassword();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  Future<void> _checkTransferPassword() async {
    await _transactionVM.verifyTransferPassword();

    if (!mounted) return;

    if (!_transactionVM.hasPassword) {
      CustomBottomSheet.show(
        context,
        height: MediaQuery.of(context).size.height * 0.35,
        iconClose: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Para efetuar a transação é necessário \ncadastrar a senha de 4 dígitos.',
                style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: const BorderSide(color: AppColors.black),
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Depois", style: TextStyle(color: AppColors.black)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: const BorderSide(color: AppColors.black),
                    ),
                  ),
                  onPressed: () {
                    PinBottomSheet.show(
                      context,
                      height: MediaQuery.of(context).size.height * 0.4,
                      title: 'Escolha uma senha de 4 dígitos',
                      autoSubmitOnComplete: false,
                      onCompleted: (transferPassword) {
                        _transactionVM.setTransferPassword(transferPassword);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    );
                  },
                  child: const Text("Cadastrar", style: TextStyle(color: AppColors.white)),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      setState(() {});
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _toKeyPixTextEditingController.clear();
    _amountTextEditingController.clear();
    _toKeyPixFocusNode.unfocus();
    _amountFocusNode.unfocus();
    setState(() {
      _transactionVM.showErrors = false;
    });
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
                Row(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enviar PIX',
                        style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          accountViewModel.toggleVisibility();
                        });
                      },
                      child: Icon(
                        accountViewModel.isHidden ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chave PIX',
                    style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _toKeyPixTextEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyBackground,
                    enabledBorder: InputBorder.none,
                    hintText: 'CPF, e-mail, telefone ou chave aleatória',
                    hintStyle: const TextStyle(color: AppColors.blackText),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  keyboardType: TextInputType.text,
                  validator: Utils.validateToPixKeyValue,
                  focusNode: _toKeyPixFocusNode,
                  onChanged: (value) {
                    final formatted = value.detectPixKeyTypeMask();
                    if (formatted != value) {
                      _toKeyPixTextEditingController
                        ..text = formatted
                        ..selection = TextSelection.collapsed(offset: formatted.length);
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Valor',
                    style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountTextEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyBackground,
                    enabledBorder: InputBorder.none,
                    hintText: 'R\$ 0,00',
                    hintStyle: const TextStyle(color: AppColors.blackText),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, BRLCurrencyInputFormatterExt()],
                  validator: Utils.validateAmount,
                  focusNode: _amountFocusNode,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "Saldo:",
                      style: TextStyle(color: AppColors.blackText, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      accountViewModel.displayBalance,
                      style: const TextStyle(color: AppColors.blackText, fontSize: 16, fontWeight: FontWeight.bold),
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
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          ),
                          onPressed: _transactionVM.hasPassword
                              ? () async {
                                  FocusScope.of(context).unfocus();

                                  if (_formKey.currentState?.validate() ?? false) {
                                    setState(() {
                                      _transactionVM.showErrors = true;
                                    });

                                    await TransferPasswordService.showAndHandle(
                                      context: context,
                                      onSuccess: () async {
                                        final double amount = BRLCurrencyInputFormatterExt.parse(
                                          _amountTextEditingController.text,
                                        );
                                        final String toPixKeyValue = _toKeyPixTextEditingController.text.replaceAll(
                                          RegExp(r'\D'),
                                          '',
                                        );

                                        final bool success = await _transactionVM.transferPix(toPixKeyValue, amount);

                                        if (!success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(_transactionVM.errorMessage ?? 'Erro ao realizar o Pix'),
                                              backgroundColor: AppColors.redError,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Pix realizado com sucesso!'),
                                              backgroundColor: AppColors.greenSuccess,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          );
                                        }

                                        if (mounted) {
                                          _resetForm();
                                        }
                                      },
                                      onError: (message) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                      },
                                    );
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _transactionVM.showErrors = true;
                                    });
                                  }
                                }
                              : null,
                          child: const Text('Transferir', style: TextStyle(color: AppColors.white)),
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
