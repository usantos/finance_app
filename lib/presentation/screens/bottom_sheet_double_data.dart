import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/statement_share_service.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BottomSheetDoubleData extends StatefulWidget {
  const BottomSheetDoubleData({super.key});

  @override
  State<BottomSheetDoubleData> createState() => _BottomSheetDoubleDataState();
}

class _BottomSheetDoubleDataState extends State<BottomSheetDoubleData> {
  DateTime? dataIni;
  DateTime? dataFim;

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionViewModel, AuthViewModel>(
      builder: (context, transactionVM, authVM, _) {
        return Center(
          child: Column(
            children: [
              Text(
                "Escolha a data que deseja ver\ndo extrato",
                style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Container(
                    child: _buildDateSelector(
                      context,
                      label: "Data de Início",
                      date: dataIni,
                      onClear: () {
                        setState(() => dataIni = null);
                      },
                      onSelect: (date) {
                        if (dataFim != null && date.isAfter(dataFim!)) {
                        } else {
                          setState(() => dataIni = date);
                        }
                      },
                    ),
                  ),
                  Container(
                    child: _buildDateSelector(
                      context,
                      label: "Data de Término",
                      date: dataFim,
                      onClear: () {
                        setState(() => dataFim = null);
                      },
                      onSelect: (date) {
                        if (dataIni != null && date.isBefore(dataIni!)) {
                        } else {
                          setState(() => dataFim = date);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(width: 1, color: AppColors.black),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar", style: TextStyle(color: AppColors.black)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: dataIni == null || dataFim == null
                          ? null
                          : () async {
                              transactionVM.setVariaveisStatementShare(dataIni, dataFim);
                              await authVM.checkCurrentUser();
                              StatementShare.captureAndSharePdf(context);
                            },
                      child: Text("Confirmar", style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildDateSelector(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onClear,
    required Function(DateTime) onSelect,
  }) {
    return Row(
      children: [
        if (date == null)
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: AppColors.black, width: 1),
              ),
            ),
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
                locale: Locale("pt", "BR"),
              );
              if (selected != null) {
                onSelect(selected);
              }
            },
            child: Text(label, style: TextStyle(color: AppColors.black)),
          ),
        if (date != null)
          Row(
            children: [
              Text(DateFormat('dd/MM/yyyy').format(date), style: TextStyle(color: AppColors.black)),
              IconButton(
                onPressed: onClear,
                icon: Icon(Icons.close, size: 16, color: AppColors.black),
              ),
            ],
          ),
      ],
    );
  }
}
