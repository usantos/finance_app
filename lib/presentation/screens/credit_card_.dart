import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  bool _showCardDetails = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.credit_card, color: AppColors.white),
                    SizedBox(width: 8),
                    Text('Cartão de Crédito', style: TextStyle(color: AppColors.white, fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: Icon(_showCardDetails ? Icons.visibility_off : Icons.visibility, color: AppColors.white),
                  onPressed: () {
                    setState(() {
                      _showCardDetails = !_showCardDetails;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _showCardDetails
                  ? () {
                      Utils.copiarTexto(
                        context,
                        transactionViewModel.creditCardModels!.creditCardNumber.toCreditCardFull(),
                        'Cartão copiado com sucesso',
                      );
                    }
                  : null,
              style: TextButton.styleFrom(fixedSize: const Size(300, 40), padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    _showCardDetails
                        ? transactionViewModel.creditCardModels!.creditCardNumber.toCreditCardFull()
                        : transactionViewModel.creditCardModels!.creditCardNumber.toCreditCardMasked(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_showCardDetails) const Icon(Icons.copy, size: 16, color: AppColors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PORTADOR', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                    Text(
                      transactionViewModel.creditCardModels!.creditCardName,
                      style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('VALIDADE', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                    Text(
                      transactionViewModel.creditCardModels!.validate,
                      style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
