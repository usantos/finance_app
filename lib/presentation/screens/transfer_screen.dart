import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/recent_contacts.dart';
import 'package:financial_app/presentation/screens/transfer_card_pix.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_appbar.dart';
import 'components/skeleton.dart';
import 'quick_actions_transfer.dart';
import 'recent_pix.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late bool _isLoad = true;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TransactionViewModel>(context, listen: false);
    viewModel.getPixKeysByAccountId();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isLoad = false;
      });
    });
  }

  Widget? _selectedWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: widget.title, description: widget.description),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoad == true
              ? const LoadSkeleton(itemCount: 8)
              : Column(
                  children: [
                    QuickActionsTransfer(
                      onSelect: (widget) {
                        setState(() {
                          _selectedWidget = widget;
                        });
                      },
                    ),
                    if (_selectedWidget != null)
                      Card(
                        color: AppColors.white,
                        margin: const EdgeInsets.all(8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.grey, width: 1),
                        ),
                        child: Padding(padding: const EdgeInsets.all(16.0), child: _selectedWidget!),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedWidget.runtimeType == TransferCardPix) ...[
                            Text(
                              'Contatos Pix recentes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const SizedBox(height: 16),
                            RecentContacts(),
                          ] else
                            const SizedBox.shrink(),

                          Text(
                            'Últimas transações',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                          ),
                          const SizedBox(height: 16),
                          RecentPix(),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              ),
                              onPressed: () {},
                              child: Text('Ver extrato completo', style: TextStyle(color: AppColors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
