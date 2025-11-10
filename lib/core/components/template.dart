import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplateScreen extends StatefulWidget {
  final String title;
  final String? description;
  final Widget body;
  final String typeTitle;
  final String? footerDescription;
  final String buttonText;
  final TextEditingController? textController;
  final String method;

  const TemplateScreen({
    super.key,
    required this.title,
    required this.typeTitle,
    this.description,
    required this.body,
    this.footerDescription,
    required this.buttonText,
    this.textController,
    required this.method,
  });

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionVM, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    const SizedBox(height: 8),
                    if (widget.description != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(widget.description!, style: TextStyle(fontSize: 18, color: AppColors.blackText)),
                      ),
                    const SizedBox(height: 32),
                    Expanded(child: SingleChildScrollView(child: widget.body)),
                    if (widget.footerDescription != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          widget.footerDescription!,
                          style: TextStyle(fontSize: 14, color: AppColors.blackText),
                        ),
                      ),
                    const SizedBox(height: 16),
                    widget.method == 'Create Pix'
                        ? SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                final isValid =
                                    widget.textController == null || _formKey.currentState?.validate() == true;
                                if (!isValid) return;

                                String keyValue = widget.textController?.text.trim() ?? '';

                                final keyType = widget.typeTitle;
                                if (keyType == 'CPF' || keyType == 'Telefone') {
                                  keyValue = keyValue.replaceAll(RegExp(r'\D'), '');
                                }

                                await transactionVM.createPixKey(keyType, keyValue);
                                transactionVM.getPixKeysByAccountId();
                                Navigator.of(context).pop();
                              },

                              child: Text(widget.buttonText, style: const TextStyle(color: AppColors.white)),
                            ),
                          )
                        : Row(
                            children: [
                              // BOTÃO CANCELAR
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // fecha o modal
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12), // espaçamento entre os botões
                              // BOTÃO CONFIRMAR
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () async {
                                      final blockType = widget.typeTitle;
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(child: CircularProgressIndicator()),
                                      );

                                      await transactionVM.updateBlockType(blockType);
                                      await Future.delayed(const Duration(seconds: 2));
                                      await transactionVM.getCreditCardByAccountId();
                                      Navigator.of(context).pop();

                                      if (context.mounted) Navigator.pop(context);
                                    },
                                    child: Text(
                                      widget.buttonText,
                                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
