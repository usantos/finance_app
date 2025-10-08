import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/credit_card_screen.dart';
import 'package:financial_app/presentation/screens/profile_screen.dart';
import 'package:financial_app/presentation/screens/statement_screen.dart';
import 'package:financial_app/presentation/screens/transfer_screen.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'main_content_screen.dart';

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
    StatementScreen(title: "Extrato", description: "Suas movimentações"),
    CreditCardScreen(title: "Cartão", description: "Cartão de crédito"),
    TransferScreen(title: "Serviços", description: "Realizar transferência"),
    ProfileScreen(title: "Perfil", description: "Suas informações pessoais"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.white, size: 22);
            }
            return const IconThemeData(color: AppColors.black, size: 22);
          }),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(color: AppColors.black, fontSize: 11)),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.white,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            if (index == _selectedIndex) return;
            setState(() => _selectedIndex = index);
            _onItemTapped(index);
          },
          height: 70,
          indicatorColor: AppColors.secondary,
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
            NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Serviços'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
