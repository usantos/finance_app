import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/screens/balance_card.dart';
import 'package:financial_app/presentation/screens/quick_actions.dart';
import 'package:financial_app/presentation/screens/recent_transactions.dart';
import 'package:provider/provider.dart';

import 'components/custom_appbar.dart';
import 'components/skeleton.dart';

class MainContentScreen extends StatefulWidget {
  const MainContentScreen({super.key});

  @override
  State<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen> {
  final _authViewModel = sl.get<AuthViewModel>();
  final _transactionViewModel = sl.get<TransactionViewModel>();
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showSkeleton = false);
    });

    _authViewModel.checkCurrentUser();
    _transactionViewModel.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
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
                padding: EdgeInsets.only(top: 30),
                child: SingleChildScrollView(child: LoadSkeleton(itemCount: 8)),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(
              toolbarSize: 168,
              title: 'Olá, ${authVM.currentUser?.user.name ?? ''}!',
              description: "Bem-vindo de volta",
              body: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [BalanceCard()]),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ações rápidas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    SizedBox(height: 16),
                    QuickActions(),
                    Text(
                      'Últimas transações',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    SizedBox(height: 16),
                    RecentTransactions(),
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
