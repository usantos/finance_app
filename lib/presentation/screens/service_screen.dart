import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/payload_card.dart';
import 'package:financial_app/presentation/screens/qr_code_card.dart';
import 'package:financial_app/presentation/screens/recent_contacts.dart';
import 'package:financial_app/presentation/screens/transfer_card.dart';
import 'package:financial_app/presentation/screens/transfer_pix_card.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_appbar.dart';
import 'components/skeleton.dart';
import 'actions_service.dart';
import 'recent_pix.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late bool _isLoad = true;
  Widget? _selectedWidget;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TransactionViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.getPixKeysByAccountId();
      setState(() => _isLoad = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransactionViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: widget.title, description: widget.description),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoad
              ? const LoadSkeleton(itemCount: 8)
              : Column(
                  children: [
                    ActionsService(
                      onSelect: (widget) {
                        viewModel.clearQrCodeData();

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
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          if (_selectedWidget.runtimeType == TransferPixCard) ...[
                            Text(
                              'Contatos Pix recentes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const RecentContacts(),
                            Text(
                              'Últimas transações PIX',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const RecentPix(),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                ),
                                onPressed: () {},
                                child: const Text('Ver extrato completo', style: TextStyle(color: AppColors.white)),
                              ),
                            ),
                          ] else if (_selectedWidget.runtimeType == QrCodeCard) ...[
                            if (!_isLoad) const PayloadCard(),
                          ] else if (_selectedWidget.runtimeType == TransferCard) ...[
                            Text(
                              'Últimas transações',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const RecentPix(),
                          ] else
                            ...[],
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
