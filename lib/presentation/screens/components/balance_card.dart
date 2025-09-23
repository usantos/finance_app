import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final accountViewModel = sl.get<AccountViewModel>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4A4A7A),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saldo disponível', style: TextStyle(color: Colors.white70, fontSize: 16)),
                InkWell(
                  onTap: () {
                    setState(() {
                      accountViewModel.toggleVisibility();
                    });
                  },
                  child: Icon(accountViewModel.isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              accountViewModel.displayBalance,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
