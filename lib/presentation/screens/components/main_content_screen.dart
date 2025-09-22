import 'package:flutter/material.dart';
import 'package:financial_app/presentation/screens/components/balance_card.dart';
import 'package:financial_app/presentation/screens/components/quick_actions.dart';
import 'package:financial_app/presentation/screens/components/recent_transactions.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/presentation/screens/components/bottom_sheet_perfil.dart';

class MainContentScreen extends StatelessWidget {
  const MainContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                RecentTransactions(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}