import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    _authViewModel.checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _authViewModel)],
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(
              toolbarSize: 168,
              title: 'Olá, ${authVM.currentUser?.user.name ?? ''}!',
              description: "Bem-vindo de volta",
              body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const BalanceCard()]),
            ),
            body: SingleChildScrollView(
              child: authVM.isLoading
                  ? const LoadSkeleton(itemCount: 5)
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ações rápidas',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                          ),
                          const SizedBox(height: 16),
                          const QuickActions(),
                          const Text(
                            'Últimas transações',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                          ),
                          const SizedBox(height: 16),
                          const RecentTransactions(),
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
