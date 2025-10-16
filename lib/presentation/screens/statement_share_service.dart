import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class UserTransaction {
  final String hour;
  final String description;
  final double balance;

  UserTransaction({required this.hour, required this.description, required this.balance});
}

class StatementShare {
  static void captureAndSharePdf(BuildContext context) async {
    final appStrings = _AppStrings();
    final transactions = _mockTransactions();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(appStrings.statement),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 4)),
              pw.Text('Cartão Exemplo'),
              pw.Text('Saldo: 1.234,56'),
              pw.Text('Última atualização: 07/10/2025 16:00'),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 8)),
              pw.Divider(height: 0.5),
              pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: transactions.map((t) => _transactionItem(t)).toList(),
          ),
        ],
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    final file = XFile.fromData(pdfBytes, name: 'statement.pdf', mimeType: 'application/pdf');
    await Share.shareXFiles([file]);
  }

  static pw.Widget _transactionItem(UserTransaction transaction) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Text(transaction.hour),
            pw.Padding(padding: const pw.EdgeInsets.only(left: 8)),
            pw.Text(transaction.description),
            pw.Spacer(),
            pw.Text(transaction.balance.toStringAsFixed(2)),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4)),
      ],
    );
  }

  static List<UserTransaction> _mockTransactions() {
    return [
      UserTransaction(hour: '08:30', description: 'Compra Supermercado', balance: 500.00),
      UserTransaction(hour: '10:45', description: 'Pagamento Luz', balance: 480.50),
      UserTransaction(hour: '12:15', description: 'Transferência Recebida', balance: 1_000.00),
      UserTransaction(hour: '15:00', description: 'Compra Online', balance: 950.25),
      UserTransaction(hour: '18:20', description: 'Saque ATM', balance: 900.00),
    ];
  }
}

class _AppStrings {
  String get statement => 'Extrato';
}
