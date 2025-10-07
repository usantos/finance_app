import 'package:financial_app/presentation/screens/statement_share_service.dart';
import 'package:flutter/material.dart';
import 'components/custom_appbar.dart';
import 'package:intl/intl.dart';
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

  final List<Transaction> _transactions = [
    Transaction(
      description: 'Transferência PIX - João Silva',
      date: DateTime(2025, 10, 6),
      time: const TimeOfDay(hour: 14, minute: 30),
      amount: 150.00,
      type: TransactionType.debit,
      category: 'Transferência',
    ),
    Transaction(
      description: 'Depósito - Salário',
      date: DateTime(2025, 10, 1),
      time: const TimeOfDay(hour: 8, minute: 0),
      amount: 3500.00,
      type: TransactionType.credit,
      category: 'Depósito',
    ),
    Transaction(
      description: 'Compra - Supermercado Extra',
      date: DateTime(2025, 10, 5),
      time: const TimeOfDay(hour: 19, minute: 45),
      amount: 185.50,
      type: TransactionType.debit,
      category: 'Compras',
    ),
    Transaction(
      description: 'PIX Recebido - Maria Santos',
      date: DateTime(2025, 08, 9),
      time: const TimeOfDay(hour: 16, minute: 20),
      amount: 75.00,
      type: TransactionType.credit,
      category: 'PIX',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final String dateLabel = _selectedDate == null
        ? 'Data do extrato'
        : DateFormat('dd/MM/yyyy').format(_selectedDate!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          CustomAppbar(title: widget.title, description: widget.description),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Buscar por descrição...',
                      hintStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list, color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.black),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(dateLabel, style: const TextStyle(color: Colors.black, fontSize: 16)),
                          ),
                          SizedBox(
                            width: 24,
                            child: _selectedDate == null
                                ? const Icon(Icons.arrow_drop_down, color: Colors.black)
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: _clearDate,
                                    icon: const Icon(Icons.close, size: 18, color: Colors.black),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),
                  
                   Align(
                     alignment: Alignment.centerRight,
                     child: IconButton(
                       autofocus: true,
                       enableFeedback: true,
                       highlightColor:  Color(0xFF2C2C54),
                       onPressed: () {
                         StatementShare.captureAndSharePdf(context);
                       },
                       icon: const Icon(Icons.download, size: 24, color: Colors.black),
                     )
                   ),
                  const SizedBox(height: 26),

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
        ],
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
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2C2C54),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFF2C2C54)),
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
