import 'package:financial_app/presentation/screens/recent_contacts.dart';
import 'package:financial_app/presentation/screens/transfer_card.dart';
import 'package:flutter/material.dart';
import 'components/custom_appbar.dart';
import 'quick_actions_pix.dart';
import 'recent_pix.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          CustomAppbar(title: widget.title, description: widget.description),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  QuickActionsPix(),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                    child: Padding(padding: const EdgeInsets.all(16.0), child: TransferCard()),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contatos recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        RecentContacts(),
                        const SizedBox(height: 24),
                        Text('Últimos PIX', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        RecentPix(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
