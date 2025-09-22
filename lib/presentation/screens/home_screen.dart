import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/screens/components/bottom_sheet_perfil.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/screens/components/balance_card.dart';
import 'package:financial_app/presentation/screens/components/quick_actions.dart';
import 'package:financial_app/presentation/screens/components/recent_transactions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final authViewModel = sl.get<AuthViewModel>();
  final accountViewModel = sl.get<AccountViewModel>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadData() async {
    await authViewModel.checkCurrentUser();
    if (authViewModel.currentUser != null) {
      await accountViewModel.fetchAccount();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            backgroundColor: const Color(0xFF2C2C54),
            pinned: true,
            expandedHeight: 220.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Olá, João!',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Bem-vindo de volta', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                  BalanceCard(),
                ],
              ),
            ),
            actions: [
              // Ícone de perfil
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    CustomBottomSheet.show(
                      iconClose: false,
                      context,
                      isDismissible: true,
                      enableDrag: true,
                      height: MediaQuery.of(context).size.height * 0.250,
                      child: const BottomSheetPerfil(),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Text(
                      'J',
                      style: TextStyle(color: Color(0xFF2C2C54), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // O resto do conteúdo da tela
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ações rápidas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  QuickActions(),
                  const SizedBox(height: 24),
                  const Text('Últimas transações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  RecentTransactions(), // Widget para a lista de transações
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        indicatorColor: Colors.blue.shade100,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Extrato',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card),
            label: 'Cartão',
          ),
          NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'PIX'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
