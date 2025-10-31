import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/statement_share_service.dart';
import 'package:flutter/material.dart';
import 'components/custom_appbar.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;
  bool _showSkeleton = true;

  final List<Transaction> _transactions = [
    Transaction(
      name: 'João Silva',
      date: DateTime(2025, 10, 6),
      time: const TimeOfDay(hour: 14, minute: 30),
      amount: 150.00,
      type: TransactionType.debit,
      category: 'PIX',
    ),
    Transaction(
      name: 'Salário',
      date: DateTime(2025, 10, 1),
      time: const TimeOfDay(hour: 8, minute: 0),
      amount: 3500.00,
      type: TransactionType.credit,
      category: 'Depósito',
    ),
    Transaction(
      name: 'Supermercado Extra',
      date: DateTime(2025, 10, 5),
      time: const TimeOfDay(hour: 19, minute: 45),
      amount: 185.50,
      type: TransactionType.debit,
      category: 'Compra',
    ),
    Transaction(
      name: 'Maria Santos',
      date: DateTime(2025, 08, 9),
      time: const TimeOfDay(hour: 16, minute: 20),
      amount: 75.00,
      type: TransactionType.credit,
      category: 'PIX',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _showSkeleton = true;
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
    final String dateLabel = _selectedDate == null
        ? 'Data do extrato'
        : DateFormat('dd/MM/yyyy').format(_selectedDate!);
    if (_showSkeleton) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppbar(title: widget.title, description: widget.description),
        body: Padding(padding: const EdgeInsets.only(top: 30), child: LoadSkeleton(itemCount: 7)),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: widget.title, description: widget.description),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  hintText: 'Buscar por descrição...',
                  hintStyle: const TextStyle(color: AppColors.black),
                  prefixIcon: const Icon(Icons.search, color: AppColors.black),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, color: AppColors.black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: _selectedDate == null ? 12 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                        child: _selectedDate == null
                            ? const Icon(Icons.arrow_drop_down, color: AppColors.black)
                            : IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: _clearDate,
                                icon: const Icon(Icons.close, size: 18, color: AppColors.black),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => StatementShare.captureAndSharePdf(context),
                  style: TextButton.styleFrom(fixedSize: const Size(150, 40), padding: EdgeInsets.zero),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Compartilhar', style: TextStyle(color: AppColors.blackText)),
                      SizedBox(width: 4),
                      Icon(Icons.download, size: 22, color: AppColors.black),
                    ],
                  ),
                ),
              ),

              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionCard(transaction: _filteredTransactions[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Transaction> get _filteredTransactions {
    if (_selectedDate == null) return _transactions;
    return _transactions.where((t) {
      return t.date.year == _selectedDate!.year &&
          t.date.month == _selectedDate!.month &&
          t.date.day == _selectedDate!.day;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _clearDate() {
    setState(() => _selectedDate = null);
  }
}
