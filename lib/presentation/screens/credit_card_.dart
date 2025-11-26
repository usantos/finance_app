import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionVM, _) {
        final creditCard = transactionVM.creditCardModels;

        if (creditCard == null) {
          return const Center(
            child: Text('Nenhum cartão encontrado', style: TextStyle(color: AppColors.white)),
          );
        }

        final showCardDetails = transactionVM.showCardDetails;
        final blockType = creditCard.blockType;

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
        }

        final isBlocked = bannerColor != null;

        return Stack(
          alignment: .center,
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.credit_card, color: AppColors.white),
                        SizedBox(width: 8),
                        Text('Cartão de Crédito', style: TextStyle(color: AppColors.white, fontSize: 16)),
                      ],
                    ),
                    IconButton(
                      icon: Icon(showCardDetails ? Icons.visibility_off : Icons.visibility, color: AppColors.white),
                      onPressed: transactionVM.toggleCardDetails,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: TextButton(
                    key: ValueKey(showCardDetails),
                    onPressed: (!showCardDetails || isBlocked)
                        ? null
                        : () {
                            Utils.copiarTexto(
                              context,
                              creditCard.creditCardNumber.toCreditCardFull(),
                              'Cartão copiado com sucesso',
                            );
                          },
                    style: TextButton.styleFrom(fixedSize: const Size(300, 40), padding: .zero),
                    child: Row(
                      children: [
                        Text(
                          showCardDetails
                              ? creditCard.creditCardNumber.toCreditCardFull()
                              : creditCard.creditCardNumber.toCreditCardMasked(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: .bold,
                            letterSpacing: 2,
                          ),
                        ),
                        if (showCardDetails && !isBlocked)
                          const Padding(
                            padding: .only(left: 8),
                            child: Icon(Icons.copy, size: 16, color: AppColors.white),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        const Text('PORTADOR', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                        Text(
                          creditCard.creditCardName.toCreditCardName(),
                          style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: .bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('VALIDADE', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                        Text(
                          creditCard.validate,
                          style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: .bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (isBlocked)
              Positioned.fill(
                child: Container(
                  color: AppColors.black.withValues(alpha: 0.45),
                  alignment: .center,
                  child: Container(
                    padding: const .symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: bannerColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      bannerText!,
                      textAlign: .center,
                      style: const TextStyle(color: AppColors.white, fontWeight: .bold, letterSpacing: 1),
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
