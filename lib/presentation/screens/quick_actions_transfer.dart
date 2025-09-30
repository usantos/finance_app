import 'package:financial_app/presentation/screens/transfer_card.dart';
import 'package:financial_app/presentation/screens/transfer_card_pix.dart';
import 'package:flutter/material.dart';

class QuickActionsTransfer extends StatefulWidget {
  const QuickActionsTransfer({super.key, required this.onSelect});

  final ValueChanged<Widget> onSelect;

  @override
  State<QuickActionsTransfer> createState() => _QuickActionsTransferState();
}

class _QuickActionsTransferState extends State<QuickActionsTransfer> {
  late List<Map<String, dynamic>> actions;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    actions = [
      {
        'icon': Icons.send,
        'label': 'Enviar Pix',
        'widget': const TransferCardPix(),
      },
      {
        'icon': Icons.call_received,
        'label': 'Receber Pix',
        'widget': null,
      },
      {
        'icon': Icons.qr_code_2_sharp,
        'label': 'QR Code Pix',
        'widget': null,
      },
      {
        'icon': Icons.compare_arrows,
        'label': 'Entre contas',
        'widget': const TransferCard(),
      },
    ];

    final initialWidget = actions[selectedIndex]['widget'] as Widget?;
    if (initialWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelect(initialWidget);
      });
    }
  }

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
          final enabled = index == selectedIndex;
          final widgetToShow = action['widget'] as Widget?;

          return Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widgetToShow != null
                  ? () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onSelect(widgetToShow);
              }
                  : null,
              child: _buildActionItem(
                context,
                action['icon'] as IconData,
                action['label'] as String,
                isEnabled: enabled,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionItem(
      BuildContext context,
      IconData icon,
      String label, {
        bool isEnabled = false,
      }) {
    final color = isEnabled ? Theme.of(context).primaryColor : Colors.grey.shade300;
    final iconColor = isEnabled ? Colors.white : Colors.grey.shade500;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ink(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
