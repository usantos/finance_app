import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:financial_app/core/components/textfield_money_underline.dart';
import 'package:financial_app/core/extensions/money_ext.dart';
import 'package:financial_app/core/services/transfer_password_service.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetAdjustLimit extends StatefulWidget {
  const BottomSheetAdjustLimit({super.key});

  @override
  State<BottomSheetAdjustLimit> createState() => _BottomSheetAdjustLimitState();
}

class _BottomSheetAdjustLimitState extends State<BottomSheetAdjustLimit> {
  final GlobalKey<MonetaryInputFieldState> _textFieldKey = GlobalKey<MonetaryInputFieldState>();
  bool _enableAction = false;
  double? _transactionValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionVM, _) {
        final double? creditCardAvailable = transactionVM.creditCardModels?.creditCardLimit;
        final double? creditCardUsed = transactionVM.creditCardModels?.creditCardUsed;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ajuste o limite disponível', style: TextStyle(color: AppColors.black, fontSize: 18)),
            const SizedBox(height: 20),
            TextFieldMoneyUnderline(
              key: _textFieldKey,
              maxValue: creditCardAvailable ?? 0.0,
              minValue: creditCardUsed ?? 0.0,
              onComplete: (value) {
                _transactionValue = value;
              },
              onValidationChanged: (isValid) {
                setState(() {
                  _enableAction = isValid;
                });
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Máximo: ${creditCardAvailable.toReal()}', style: TextStyle(color: AppColors.black)),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Minimo: ${creditCardUsed.toReal()}', style: TextStyle(color: AppColors.black)),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                ),
                onPressed: _enableAction
                    ? () async {
                        await TransferPasswordService.showAndHandle(
                          context: context,
                          onSuccess: () async {
                            final newLimit = _transactionValue;

                            final bool success = await transactionVM.adjustLimit(newLimit!);

                            if (success) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(child: CircularProgressIndicator()),
                              );
                              await transactionVM.getCreditCardByAccountId();
                              await Future.delayed(const Duration(seconds: 2));
                              if (context.mounted) Navigator.pop(context);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Limite ajustado com sucesso!'),
                                  backgroundColor: AppColors.greenSuccess,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(transactionVM.errorMessage ?? 'Erro ao ajustar limite'),
                                  backgroundColor: AppColors.redError,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          },
                        );
                      }
                    : null,
                child: const Text('Confirmar', style: TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}
