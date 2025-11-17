import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/services/transfer_password_service.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayloadCard extends StatefulWidget {
  const PayloadCard({super.key});

  @override
  State<PayloadCard> createState() => _PayloadCardState();
}

class _PayloadCardState extends State<PayloadCard> {
  final _formKey = GlobalKey<FormState>();
  final _payloadController = TextEditingController();
  final _payloadFocusNode = FocusNode();

  @override
  void dispose() {
    _payloadController.dispose();
    _payloadFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionVM, _) {
        return Card(
          color: AppColors.white,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.grey, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pagar com Copia e cola',
                    style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _payloadController,
                    focusNode: _payloadFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyBackground,
                      labelText: 'Cole o código copiado',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                    validator: Utils.validateEmpty,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            transactionVM.showErrors = true;
                          });

                          await transactionVM.getQrCode(_payloadController.text);

                          if (transactionVM.toQrCode.isNotEmpty) {
                            final firstItem = transactionVM.toQrCode.first!;
                            final nome = firstItem['name'] ?? '';
                            final amount = firstItem['amount']?.toString().toRealString() ?? '0';
                            final amountValue = firstItem['amount'] ?? 0;
                            final toPayloadValue = firstItem['payload'] ?? '';

                            await TransferPasswordService.showAndHandle(
                              context: context,
                              title: 'Deseja transferir $amount para $nome?',
                              onSuccess: () async {
                                final bool success = await transactionVM.transferQrCode(toPayloadValue, amountValue);

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Pagamento realizado com sucesso!'),
                                      backgroundColor: AppColors.greenSuccess,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                  transactionVM.getTransactions();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(transactionVM.errorMessage ?? 'Erro ao realizar pagamento'),
                                      backgroundColor: AppColors.redError,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                }

                                if (mounted) {
                                  _payloadController.clear();
                                  _payloadFocusNode.unfocus();
                                  setState(() {
                                    transactionVM.showErrors = false;
                                  });
                                }
                              },

                              onError: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: AppColors.redError,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          } else {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              transactionVM.showErrors = true;
                            });
                          }
                        }
                      },
                      child: const Text('Transferir', style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
