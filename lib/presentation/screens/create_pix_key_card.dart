/*import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/bottom_sheet_create_pix_key.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

 @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        final pixKeys = viewModel;

       if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Suas chaves PIX',
                  style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Icon(Icons.visibility_off, color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (pixKeys.isEmpty)
              Text('Nenhuma chave Pix cadastrada.', style: TextStyle(color: AppColors.black))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pixKeys.length,
                itemBuilder: (context, index) {
                  final pix = pixKeys[index];
                  return _pixKeys(
                    icon: _getIconByType(pix?.keyType),
                    text: pix?.keyType ?? 'Chave PIX',
                    subText: pix?.keyValue ?? '',
                  );
                },
              ),

            const SizedBox(height: 18),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                ),
                onPressed: () {
                  CustomBottomSheet.show(
                    iconClose: true,
                    context,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    isDismissible: true,
                    enableDrag: false,
                    child: const BottomSheetCreatePixKey(),
                  );
                },
                child: const Text('Cadastrar chave Pix', style: TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _pixKeys({required IconData icon, required String text, required String subText}) {
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

  IconData _getIconByType(String? type) {
    switch (type?.toUpperCase()) {
      case 'EMAIL':
        return Icons.email;
      case 'PHONE':
        return Icons.phone;
      case 'CPF':
        return Icons.badge;
      case 'RANDOM':
        return Icons.shield_outlined;
      default:
        return Icons.vpn_key;
    }
  }
}
*/