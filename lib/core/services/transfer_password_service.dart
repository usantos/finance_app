import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class TransferPasswordService {
  static Future<bool> showAndHandle({
    required BuildContext context,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    final transactionVM = context.read<TransactionViewModel>();
    bool result = false;

    await PinBottomSheet.show(
      context,
      autoSubmitOnComplete: false,
      height: MediaQuery.of(context).size.height * 0.42,
      title: 'Insira sua senha de 4 dígitos',
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
