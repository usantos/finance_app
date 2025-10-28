import 'dart:convert';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;

class QrCodeCard extends StatefulWidget {
  const QrCodeCard({super.key});

  @override
  State<QrCodeCard> createState() => _QrCodeCardState();
}

class _QrCodeCardState extends State<QrCodeCard> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _amountfocusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _amountfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, _) {
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
                  controller: _amountController,
                  focusNode: _amountfocusNode,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.greyBackground,
                    labelText: 'Digite o valor que deseja receber',
                    hintText: 'R\$ 0,00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, BRLCurrencyInputFormatterExt()],
                  validator: Utils.validateAmount,
                ),

              if (qrCode != null)
                Center(
                  child: Column(
                    children: [
                      qr.QrImageView(data: qrString!, version: qr.QrVersions.auto, size: 250.0),
                      const SizedBox(height: 8),
                      StreamBuilder<Duration>(
                        stream: Stream.periodic(
                          const Duration(seconds: 1),
                          (_) => viewModel.expiresAt!.difference(DateTime.now()),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          final remaining = snapshot.data!;
                          if (remaining.isNegative) {
                            final txid = qrCode['txid'];
                            viewModel.deleteQrCode(txid);
                            return const SizedBox();
                          }

                          final adjusted = remaining - const Duration(seconds: 1);
                          final m = adjusted.inMinutes.toString().padLeft(2, '0');
                          final s = (adjusted.inSeconds % 60).toString().padLeft(2, '0');
                          return Text("Expira em $m:$s", style: const TextStyle(fontSize: 16, color: AppColors.black));
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              Center(
                child: qrCode == null
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final amount = BRLCurrencyInputFormatterExt.parse(_amountController.text);
                            await viewModel.createQrCodePix(amount);
                          }
                        },
                        child: const Text('Gerar QR Code', style: TextStyle(color: AppColors.white)),
                      )
                    : Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            ),
                            onPressed: () {
                              final payload = qrCode['payload'] ?? '';
                              Utils.copiarTexto(context, payload, "Chave copiada com sucesso");
                            },
                            child: const Text('Copia e cola', style: TextStyle(color: AppColors.white)),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            ),
                            onPressed: () async {
                              CustomBottomSheet.show(
                                iconClose: false,
                                context,
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Deseja realmente excluir o QR Code?",
                                        style: const TextStyle(fontSize: 18, color: AppColors.black),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7),
                                                side: const BorderSide(color: AppColors.black),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancelar', style: TextStyle(color: AppColors.black)),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                            ),
                                            onPressed: () async {
                                              final txid = qrCode['txid'] ?? '';
                                              await viewModel.deleteQrCode(txid);
                                              _amountController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Confirmar', style: TextStyle(color: AppColors.white)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text('Excluir QR Code', style: TextStyle(color: AppColors.white)),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
