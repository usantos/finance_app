import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_appbar.dart';
import 'components/transaction_card.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final _transactionViewModel = sl.get<TransactionViewModel>();
  bool _showCardDetails = true;

  final List<Transaction> _transactions = [
    Transaction(
      name: 'Vivo',
      description: 'Pagamento Automático',
      date: DateTime(2025, 10, 6),
      time: const TimeOfDay(hour: 14, minute: 30),
      amount: 50.00,
      type: TransactionType.debit,
      category: 'Serviço',
    ),
    Transaction(
      name: 'Spotify',
      description: 'Pagamento Automático',
      date: DateTime(2025, 10, 1),
      time: const TimeOfDay(hour: 8, minute: 0),
      amount: 35.00,
      type: TransactionType.debit,
      category: 'Serviço',
    ),
    Transaction(
      name: 'Amazon',
      date: DateTime(2025, 10, 5),
      time: const TimeOfDay(hour: 19, minute: 45),
      amount: 185.50,
      type: TransactionType.debit,
      category: 'Compra',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _transactionViewModel.getCreditCardByAccountId();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, child) {
        final creditCard = transactionViewModel.creditCard;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppbar(title: widget.title, description: widget.description),
          body: creditCard.isNotEmpty
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.credit_card, color: AppColors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cartão de Crédito',
                                    style: TextStyle(color: AppColors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  _showCardDetails ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showCardDetails = !_showCardDetails;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: _showCardDetails
                                ? () {
                              Utils.copiarTexto(
                                context,
                                '1234 5678 9012 3456',
                                'Cartão copiado com sucesso',
                              );
                            }
                                : null,
                            style: TextButton.styleFrom(
                              fixedSize: const Size(300, 40),
                              padding: EdgeInsets.zero,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _showCardDetails
                                      ? '1234  5678  9012  3456'
                                      : '****  ****  ****  3456',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_showCardDetails)
                                  const Icon(Icons.copy, size: 16, color: AppColors.white),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('PORTADOR', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                                  Text(
                                    'JOÃO SILVA',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  Text('VALIDADE', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                                  Text(
                                    '12/28',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.lock_outline, color: AppColors.black),
                          label: const Text('Bloquear', style: TextStyle(color: AppColors.black)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.settings_outlined, color: AppColors.black),
                          label: const Text('Configurar', style: TextStyle(color: AppColors.black)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: const Text(
                    'Limite disponível',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLimitRow('Limite total', 'R\$ 5.000,00', AppColors.black),
                        _buildLimitRow('Disponível', 'R\$ 4.250,00', AppColors.green),
                        _buildLimitRow('Utilizado', 'R\$ 750,00', AppColors.red),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Compras recentes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          return TransactionCard(transaction: _transactions[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.credit_card_outlined, size: 80, color: AppColors.blackText),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum cartão encontrado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackText),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Criar novo cartão',
                    style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLimitRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: AppColors.blackText)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
