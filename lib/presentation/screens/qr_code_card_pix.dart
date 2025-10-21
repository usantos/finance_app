import 'dart:convert';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;

class QrCodePixCard extends StatefulWidget {
  const QrCodePixCard({super.key});

  @override
  State<QrCodePixCard> createState() => _QrCodePixCardState();
}

class _QrCodePixCardState extends State<QrCodePixCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountTextEditingController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final qrCode = viewModel.qrCode;
        final qrString = qrCode != null ? jsonEncode(qrCode) : null;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Receba com QR Code',
                style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (qrCode == null)
                TextFormField(
                  controller: _amountTextEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyBackground,
                    enabledBorder: InputBorder.none,
                    labelText: 'Digite o valor que deseja receber',
                    hintText: 'R\$ 0,00',
                    hintStyle: const TextStyle(color: AppColors.blackText),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, BRLCurrencyInputFormatterExt()],
                  validator: Utils.validateAmount,
                  focusNode: _amountFocusNode,
                ),

              if (qrCode != null)
                Center(
                  child: qr.QrImageView(data: qrString!, version: qr.QrVersions.auto, size: 250.0),
                ),

              const SizedBox(height: 12),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final double amount = BRLCurrencyInputFormatterExt.parse(_amountTextEditingController.text);
                      await viewModel.qrCodePix(amount);
                    }
                  },
                  child: const Text('Gerar QR Code', style: TextStyle(color: AppColors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
