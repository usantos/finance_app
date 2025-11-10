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
      builder: (context, transactionVM, _) {
        final creditCard = transactionVM.creditCardModels;
        final blockType = creditCard?.blockType;

        Color? bannerColor;
        String? bannerText;

        switch (blockType) {
          case 'BLOCKED_DEF':
            bannerColor = AppColors.redAccent;
            bannerText = 'BLOQUEADO DEFINITIVAMENTE';
            break;
          case 'BLOCKED_TMP':
            bannerColor = AppColors.orangeAccent;
            bannerText = 'BLOQUEADO TEMPORARIAMENTE';
            break;
          case 'BLOCKED_PRV':
            bannerColor = AppColors.blueAccent;
            bannerText = 'BLOQUEIO PREVENTIVO ATIVO';
            break;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
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
                            transactionVM.creditCardModels!.creditCardNumber.toCreditCardFull(),
                            'Cartão copiado com sucesso',
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(fixedSize: const Size(300, 40), padding: EdgeInsets.zero),
                  child: Row(
                    children: [
                      Text(
                        _showCardDetails
                            ? transactionVM.creditCardModels!.creditCardNumber.toCreditCardFull()
                            : transactionVM.creditCardModels!.creditCardNumber.toCreditCardMasked(),
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
                          transactionVM.creditCardModels!.creditCardName,
                          style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('VALIDADE', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                        Text(
                          transactionVM.creditCardModels!.validate,
                          style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (bannerColor != null && bannerText != null)
              Positioned.fill(
                child: Container(
                  color: AppColors.black.withValues(alpha: 0.45),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: bannerColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      bannerText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
