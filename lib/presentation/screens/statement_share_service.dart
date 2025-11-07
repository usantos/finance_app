import 'dart:typed_data';
import 'package:financial_app/domain/model/transaction_model.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';

class StatementShare {
  static Future<void> captureAndSharePdf(BuildContext context) async {
    final _transactionVM = Provider.of<TransactionViewModel>(context, listen: false);
    final _accountVM = Provider.of<AccountViewModel>(context, listen: false);

    final transactions = _transactionVM.transactionModels;
    final amount = _accountVM.account?.balance;

    if (transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhuma transação para exportar.')));
      return;
    }

    final pdf = pw.Document();
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    double totalCredit = 0;
    double totalDebit = 0;

    for (final t in transactions) {
      if (t.type == TransactionType.credit) {
        totalCredit += t.amount;
      } else {
        totalDebit += t.amount;
      }
    }



    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Extrato de Transações',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
              ),
              pw.SizedBox(height: 6),
              pw.Text('Gerado em: ${dateFormat.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 6),
              pw.Text(
                'Total de Créditos: ${formatter.format(totalCredit)}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.green800),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Total de Débitos: ${formatter.format(totalDebit)}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.red800),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Saldo Atual: ${formatter.format(amount)}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: amount! >= 0 ? PdfColors.green800 : PdfColors.red800,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1, color: PdfColors.grey600),
              pw.SizedBox(height: 8),
            ],
          ),

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < transactions.length; i++) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(dateFormat.format(transactions[i].date), style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        '${transactions[i].toAccountName ?? '-'}\n(${transactions[i].category})',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        transactions[i].type == TransactionType.credit ? 'Crédito' : 'Débito',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: transactions[i].type == TransactionType.credit ? PdfColors.green800 : PdfColors.red800,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          formatter.format(transactions[i].amount),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                if (i != transactions.length - 1) pw.Divider(thickness: 0.5, color: PdfColors.grey600),
                pw.SizedBox(height: 4),
              ],
            ],
          ),

          pw.SizedBox(height: 4),
          pw.Divider(thickness: 0.8, color: PdfColors.grey500),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Gerado por Close Finance App',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    final file = XFile.fromData(pdfBytes, name: 'extrato.pdf', mimeType: 'application/pdf');
    await Share.shareXFiles([file]);
  }
}
