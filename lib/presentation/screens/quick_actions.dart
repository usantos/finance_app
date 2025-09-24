import 'package:flutter/material.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  final List<Map<String, dynamic>> actions = [
    {'icon': Icons.send, 'label': 'PIX', 'enabled': true},
    {'icon': Icons.payment, 'label': 'Pagar', 'enabled': true},
    {'icon': Icons.credit_card, 'label': 'Cartão', 'enabled': true},
    {'icon': Icons.phone_android, 'label': 'Recarga', 'enabled': true},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildActionItem(
            context,
            action['icon'] as IconData,
            action['label'] as String,
            isEnabled: action['enabled'] == true,
          );
        },
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, {bool isEnabled = false}) {
    final color = isEnabled ? Theme.of(context).primaryColor : Colors.grey.shade300;
    final iconColor = isEnabled ? Colors.white : Colors.grey.shade500;

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
