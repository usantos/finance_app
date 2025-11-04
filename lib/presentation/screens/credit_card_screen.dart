import 'package:financial_app/core/components/pin_bottom_sheet.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/components/skeleton.dart';
import 'package:financial_app/presentation/screens/credit_card_.dart';
import 'package:financial_app/presentation/screens/credit_limit_card.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_appbar.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    _showSkeleton = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionViewModel = Provider.of<TransactionViewModel>(context, listen: false);
      transactionViewModel.getCreditCardByAccountId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, child) {
        if (_showSkeleton) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(title: widget.title, description: widget.description),
            body: const Padding(
              padding: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(child: LoadSkeleton(itemCount: 8)),
            ),
          );
        }
        final creditCard = transactionViewModel.creditCardModels;
        final blockType = creditCard?.blockType;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppbar(title: widget.title, description: widget.description),
          body: transactionViewModel.creditCardModels != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: CreditCard(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            blockType == "ACTIVE"
                                ? Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(child: CircularProgressIndicator()),
                                        );

                                        await transactionViewModel.updateBlockType("BLOCKED");
                                        await Future.delayed(const Duration(seconds: 2));
                                        await transactionViewModel.getCreditCardByAccountId();

                                        if (context.mounted) Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.lock_outline, color: AppColors.black),
                                      label: const Text('Bloquear', style: TextStyle(color: AppColors.black)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        side: const BorderSide(color: AppColors.grey),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(child: CircularProgressIndicator()),
                                        );

                                        await transactionViewModel.updateBlockType("ACTIVE");
                                        await Future.delayed(const Duration(seconds: 2));
                                        await transactionViewModel.getCreditCardByAccountId();

                                        if (context.mounted) Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.lock_open_outlined, color: AppColors.black),
                                      label: const Text('Desbloquear', style: TextStyle(color: AppColors.black)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        side: const BorderSide(color: AppColors.grey),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.settings_outlined, color: AppColors.black),
                                label: const Text('Configurar', style: TextStyle(color: AppColors.black)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: AppColors.grey),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: const Text(
                          'Limite disponível',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                        ),
                      ),
                      CreditLimitCard(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Compras recentes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Nenhuma compra realizada',
                              style: TextStyle(fontSize: 14, color: AppColors.blackText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.credit_card_outlined, size: 80, color: AppColors.blackText),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum cartão encontrado',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackText),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          PinBottomSheet.show(
                            autoSubmitOnComplete: false,
                            height: MediaQuery.of(context).size.height * 0.4,
                            context,
                            title: "Escolha uma senha de 4 dígitos",
                            onCompleted: (password) async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(child: CircularProgressIndicator()),
                              );

                              await transactionViewModel.createCreditCard(password);
                              await Future.delayed(const Duration(seconds: 2));
                              await transactionViewModel.getCreditCardByAccountId();

                              if (context.mounted) Navigator.pop(context);
                            },
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Solicitar novo cartão',
                          style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
