import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/screens/components/bottom_sheet_perfil.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:financial_app/presentation/screens/balance_screen.dart';
import 'package:financial_app/presentation/screens/history_screen.dart';
import 'package:financial_app/presentation/screens/statement_screen.dart';
import 'package:financial_app/presentation/screens/transfer_screen.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _authViewModel = sl.get<AuthViewModel>();

  static final List<Widget> _widgetOptions = <Widget>[
    BalanceScreen(),
    StatementScreen(),
    TransferScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        actions: [
          const SizedBox(width: 16),
          InkWell(
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
            child: const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/avatar_placeholder.png')),
          ),
          const Spacer(),
          Consumer<AccountViewModel>(
            builder: (context, accountViewModel, child) {
              if (_selectedIndex == 0 || _selectedIndex == 2) {
                return IconButton(
                  key: const Key('toggle_visibility_button'),
                  onPressed: () {
                    accountViewModel.toggleVisibility();
                  },
                  icon: Icon(accountViewModel.isHidden ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _authViewModel.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(12.0), child: _widgetOptions[_selectedIndex]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Saldo',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Extrato',
          ),
          NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Transferir'),
          NavigationDestination(
            icon: Icon(Icons.history_toggle_off),
            selectedIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
