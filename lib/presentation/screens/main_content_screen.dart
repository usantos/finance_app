import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/screens/balance_card.dart';
import 'package:financial_app/presentation/screens/quick_actions.dart';
import 'package:financial_app/presentation/screens/recent_transactions.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _authViewModel.checkCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _authViewModel)],
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                backgroundColor: const Color(0xFF2C2C54),
                pinned: true,
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background:   authVM.isLoading
                      ?  const LoadSkeleton(itemCount: 2,)
                      :Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Olá, ${authVM.currentUser?.user.name ?? ''}!',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Bem-vindo de volta', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ),
                      const BalanceCard(),
                    ],
                  ),
                ),
                actions: [
                  authVM.isLoading
                      ? SizedBox.shrink()
                      :
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF4A4A7A),
                      child: Text(
                        authVM.currentUser?.user.name.firstLetter ?? '',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child:  authVM.isLoading
                    ? const LoadSkeleton(itemCount: 8)
                    :Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ações rápidas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const QuickActions(),
                      const Text('Últimas transações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const RecentTransactions(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
