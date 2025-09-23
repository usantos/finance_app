import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/screens/history_screen.dart';
import 'package:financial_app/presentation/screens/profile_screen.dart';
import 'package:financial_app/presentation/screens/statement_screen.dart';
import 'package:financial_app/presentation/screens/transfer_screen.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'components/main_content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final authViewModel = sl.get<AuthViewModel>();
  final accountViewModel = sl.get<AccountViewModel>();

  static const List<Widget> _widgetOptions = <Widget>[
    MainContentScreen(),
    StatementScreen(title: "Extrato", description: "Suas movimentções"),
    HistoryScreen(),
    TransferScreen(title: "PIX", description: "Transferência instantânea"),
    ProfileScreen(title: "Perfil", description: "Suas informações pessoais"),
  ];

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
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),

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
