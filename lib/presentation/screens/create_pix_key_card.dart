import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePixKeyCard extends StatefulWidget {
  const CreatePixKeyCard({super.key});

  @override
  State<CreatePixKeyCard> createState() => _CreatePixKeyCardState();
}

class _CreatePixKeyCardState extends State<CreatePixKeyCard> {
  final _transactionViewModel = sl.get<TransactionViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, child) {
        return Column(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Suas chaves PIX',
                    style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {});
                  },
                  child: Icon(Icons.visibility_off, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            _pixKeys(icon: Icons.phone, text: 'Celular', subText: ("(11)999999999")),
            _pixKeys(icon: Icons.phone, text: 'Celular', subText: ("(11)999999999")),
            _pixKeys(icon: Icons.phone, text: 'Celular', subText: ("(11)999999999")),
            _pixKeys(icon: Icons.phone, text: 'Celular', subText: ("(11)999999999")),
          ],
        );
      },
    );
  }

  Widget _pixKeys({required IconData icon, required String text, required subText}) {
    return Card(
      elevation: 0,
      color: AppColors.greyBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.black, size: 20),
        title: Text(text, style: const TextStyle(color: AppColors.black)),
        subtitle: Text(subText, style: const TextStyle(color: AppColors.black)),
        trailing: const Icon(Icons.copy, size: 16, color: AppColors.black),
      ),
    );
  }
}
