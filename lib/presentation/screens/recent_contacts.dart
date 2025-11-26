import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RecentContacts extends StatefulWidget {
  const RecentContacts({super.key});

  @override
  State<RecentContacts> createState() => _RecentContactsState();
}

class _RecentContactsState extends State<RecentContacts> {
  final List<Map<String, dynamic>> contacts = [
    {'name': 'Victor'},
    {'name': 'Ana'},
    {'name': 'João'},
    {'name': 'Mariana'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: .zero,
        scrollDirection: .horizontal,
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return _buildContactItem(context, contact['name'] as String);
        },
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, String name) {
    final color = AppColors.primary;
    final textColor = AppColors.white;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: .center,
          child: Text(
            initial,
            style: TextStyle(color: textColor, fontSize: 25, fontWeight: .bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: .w500, color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
