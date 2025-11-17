import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class TransferPasswordService {
  static Future<bool> showAndHandle({
    required BuildContext context,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
    String title = "Insira sua senha de 4 dígitos",
  }) async {
    final transactionVM = context.read<TransactionViewModel>();
    bool result = false;

    await PinBottomSheet.show(
      context,
      autoSubmitOnComplete: false,
      height: 320,
      title: title,
      onCompleted: (transferPassword) async {
        final bool success = await transactionVM.validateTransferPassword(transferPassword);

        result = success;

        if (success) {
          onSuccess?.call();
        } else {
          onError?.call(transactionVM.errorMessage ?? 'Senha incorreta ou erro na validação.');
        }
      },
    );

    return result;
  }
}
