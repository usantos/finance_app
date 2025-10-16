import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';

class TemplateScreen extends StatefulWidget {
  final String title;
  final String? description;
  final Widget body;
  final String typeTitle;
  final String? footerDescription;
  final String buttonText;
  final TextEditingController? textController;

  const TemplateScreen({
    super.key,
    required this.title,
    required this.typeTitle,
    this.description,
    required this.body,
    this.footerDescription,
    required this.buttonText,
    this.textController,
  });

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final _transactionViewModel = sl.get<TransactionViewModel>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    child: Text(widget.footerDescription!, style: TextStyle(fontSize: 14, color: AppColors.blackText)),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final isValid = widget.textController == null || _formKey.currentState?.validate() == true;
                      if (!isValid) return;

                      final keyType = widget.typeTitle;
                      final keyValue = widget.textController?.text.trim() ?? '';

                      await _transactionViewModel.createPixKey(keyType, keyValue);

                      Navigator.of(context).pop();
                    },
                    child: Text(widget.buttonText, style: const TextStyle(color: AppColors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
