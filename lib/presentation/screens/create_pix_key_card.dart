import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
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
  final _viewModel = sl.get<TransactionViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final pixKeys = viewModel.pixKeys;

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
                /* InkWell(
                  onTap: () {
                    viewModel.getPixKeys();
                  },
                  child: const Icon(Icons.refresh, color: AppColors.black),
                ), */
              ],
            ),
            const SizedBox(height: 10),

            if (pixKeys.isEmpty)
              const Text('Nenhuma chave Pix cadastrada.', style: TextStyle(color: AppColors.black))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pixKeys.length,
                itemBuilder: (context, index) {
                  final pix = pixKeys[index];
                  final keyType = pix?['keyType'];
                  return _pixKeys(
                    text: pix?['keyType'] ?? 'Chave PIX',
                    subText: pix?['keyValue'] ?? '',
                    keyType: keyType,
                  );
                },
              ),

            const SizedBox(height: 20),
            pixKeys.length == 4
                ? SizedBox.shrink()
                : Center(
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

  Widget _pixKeys({required String text, required String subText, required String? keyType}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      elevation: 0,
      color: AppColors.greyBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 9),
        title: Text(text, style: const TextStyle(color: AppColors.black, fontSize: 16)),
        subtitle: Text(subText.toShort(), style: const TextStyle(color: AppColors.black, fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Utils.copiarTexto(context, subText, "Chave copiada com sucesso");
              },
              icon: const Icon(Icons.copy, size: 16, color: AppColors.black),
            ),
            IconButton(
              onPressed: () async {
                if (keyType != null) {
                  await _viewModel.deletePixKey(keyType);
                  final viewModel = Provider.of<TransactionViewModel>(context, listen: false);
                  viewModel.getPixKeysByAccountId();
                }
              },
              icon: const Icon(Icons.delete, color: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}
