import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/bottom_sheet_double_data.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'components/custom_appbar.dart';
import 'components/skeleton.dart';
import 'components/transaction_card.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  bool _showSkeleton = true;
  String _searchQueryBegin = '';
  DateTime? _selectedDateBegin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionVM = Provider.of<TransactionViewModel>(context, listen: false);
      transactionVM.getTransactions();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSkeleton) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppbar(title: widget.title, description: widget.description),
        body: const Padding(
          padding: .only(top: 30),
          child: SingleChildScrollView(child: LoadSkeleton(itemCount: 8)),
        ),
      );
    }

    return Consumer2<TransactionViewModel, AuthViewModel>(
      builder: (context, transactionVM, authVM, _) {
        final String dateLabel = transactionVM.selectedDateBegin == null
            ? 'Data do extrato'
            : DateFormat('dd/MM/yyyy').format(transactionVM.selectedDateBegin!);
        final transactions = transactionVM.filteredTransactions;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppbar(title: widget.title, description: widget.description),
          body: SingleChildScrollView(
            child: Padding(
              padding: const .all(18.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  TextField(
                    onChanged: (value) => setState(() => transactionVM.setVariaveis(value, _selectedDateBegin)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Buscar por nome da conta...',
                      hintStyle: const TextStyle(color: AppColors.black),
                      prefixIcon: const Icon(Icons.search, color: AppColors.black),

                      contentPadding: const .symmetric(vertical: 10.0),
                      border: const OutlineInputBorder(borderRadius: .all(Radius.circular(12))),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey),
                        borderRadius: .all(Radius.circular(12)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey),
                        borderRadius: .all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () => _selectDateBegin(context),
                    child: Container(
                      padding: .symmetric(horizontal: 12, vertical: transactionVM.selectedDateBegin == null ? 12 : 0),
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: AppColors.black),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(dateLabel, style: const TextStyle(color: AppColors.black, fontSize: 16)),
                          ),
                          SizedBox(
                            width: 24,
                            child: transactionVM.selectedDateBegin == null
                                ? const Icon(Icons.arrow_drop_down, color: AppColors.black)
                                : IconButton(
                                    padding: .zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: transactionVM.clearVariaveis,
                                    icon: const Icon(Icons.close, size: 18, color: AppColors.black),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: .centerRight,
                    child: TextButton(
                      onPressed: () async {
                        CustomBottomSheet.show(context, height: 240, child: BottomSheetDoubleData());
                      },
                      style: TextButton.styleFrom(fixedSize: const Size(150, 40), padding: .zero),
                      child: const Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Compartilhar', style: TextStyle(color: AppColors.blackText)),
                          SizedBox(width: 4),
                          Icon(Icons.download, size: 22, color: AppColors.black),
                        ],
                      ),
                    ),
                  ),

                  if (transactions.isEmpty)
                    const Text(
                      'Nenhuma transação encontrada.',
                      style: TextStyle(fontSize: 14, color: AppColors.blackText),
                    )
                  else
                    ListView.builder(
                      padding: .zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(transaction: transactions[index]);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDateBegin(BuildContext context) async {
    final transactionVM = Provider.of<TransactionViewModel>(context, listen: false);

    final DateTime today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: transactionVM.selectedDateBegin ?? today,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => _selectedDateBegin = pickedDate);

      transactionVM.setVariaveis(_searchQueryBegin, _selectedDateBegin);
    }
  }
}
