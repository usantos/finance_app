import 'package:flutter/material.dart';

class QuickActionsPix extends StatefulWidget {
  const QuickActionsPix({super.key});

  @override
  State<QuickActionsPix> createState() => _QuickActionsPixState();
}

class _QuickActionsPixState extends State<QuickActionsPix> {
  final List<Map<String, dynamic>> actions = [
    {'icon': Icons.send, 'label': 'Enviar', 'enabled': true},
    {'icon': Icons.call_received, 'label': 'Receber', 'enabled': false},
    {'icon': Icons.qr_code_2_sharp, 'label': 'QR Code', 'enabled': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: actions
            .map((action) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: _buildActionItem(
            context,
            action['icon'] as IconData,
            action['label'] as String,
            isEnabled: action['enabled'] == true,
          ),
        ))
            .toList(),
      ),
    );
  }


  Widget _buildActionItem(BuildContext context, IconData icon, String label, {bool isEnabled = false}) {
    final color = isEnabled ? Theme.of(context).primaryColor : Colors.grey.shade300;
    final iconColor = isEnabled ? Colors.white : Colors.grey.shade500;

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}