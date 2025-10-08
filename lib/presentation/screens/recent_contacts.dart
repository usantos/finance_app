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
      height: 120,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
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
    final color = Color(0xFF2C2C54);
    final textColor = Colors.white;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
