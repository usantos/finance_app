import 'dart:math';

import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/screens/balance_card.dart';
import 'package:financial_app/presentation/screens/quick_actions.dart';
import 'package:provider/provider.dart';

import 'components/custom_appbar.dart';
import 'components/skeleton.dart';
import 'components/transaction_card.dart';

class MainContentScreen extends StatefulWidget {
  const MainContentScreen({super.key});

  @override
  State<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen> {
  final _authViewModel = sl.get<AuthViewModel>();
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<TransactionViewModel>(context, listen: false);
      viewModel.getTransactions();
    });
    _authViewModel.checkCurrentUser();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showSkeleton = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authViewModel,
      child: Consumer2<AuthViewModel, TransactionViewModel>(
        builder: (context, authVM, transactionVM, _) {
          if (_showSkeleton) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: CustomAppbar(
                toolbarSize: 168,
                body: Column(
                  children: const [LoadSkeleton(itemCount: 1, height: 30), LoadSkeleton(itemCount: 1, height: 70)],
                ),
              ),
              body: const Padding(
                padding: .only(top: 30),
                child: SingleChildScrollView(child: LoadSkeleton(itemCount: 8)),
              ),
            );
          }
          final transactions = transactionVM.transactionLastWeekModels;

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(
              toolbarSize: 168,
              title: 'Olá, ${authVM.currentUser?.user.name.showThreeNames() ?? ''}!',
              description: "Bem-vindo de volta",
              body: const Column(crossAxisAlignment: .start, children: [BalanceCard()]),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const .all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      'Ações rápidas',
                      style: TextStyle(fontSize: 16, fontWeight: .bold, color: AppColors.black),
                    ),
                    const SizedBox(height: 16),

                    const QuickActions(),
                    const SizedBox(height: 16),

                    const Text(
                      'Últimas transações',
                      style: TextStyle(fontSize: 16, fontWeight: .bold, color: AppColors.black),
                    ),
                    const SizedBox(height: 16),
                    if (transactions.isEmpty)
                      const Text(
                        'Nenhuma transação encontrada nos últimos 7 dias',
                        style: TextStyle(fontSize: 14, color: AppColors.blackText),
                      )
                    else
                      ListView.builder(
                        padding: .zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: min(transactions.length, 5),
                        itemBuilder: (context, index) {
                          return TransactionCard(transaction: transactions[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
