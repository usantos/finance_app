import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/pix_key_card.dart';
import 'package:financial_app/presentation/screens/qr_code_card.dart';
import 'package:financial_app/presentation/screens/transfer_card.dart';
import 'package:financial_app/presentation/screens/transfer_pix_card.dart';
import 'package:flutter/material.dart';

class ActionsService extends StatefulWidget {
  const ActionsService({super.key, required this.onSelect});

  final ValueChanged<Widget> onSelect;

  @override
  State<ActionsService> createState() => _ActionsServiceState();
}

class _ActionsServiceState extends State<ActionsService> {
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> actions;
  int selectedIndex = 0;

  static const double kItemWidth = 90.0;
  static const double kIconBoxSize = 70.0;
  static const double kSeparator = 1.0;

  @override
  void initState() {
    super.initState();
    actions = [
      {'icon': Icons.send, 'label': 'Enviar Pix', 'widget': const TransferPixCard()},
      {'icon': Icons.call_received, 'label': 'Chaves Pix', 'widget': const PixKeyCard()},
      {'icon': Icons.qr_code_2_sharp, 'label': 'QR Code', 'widget': const QrCodeCard()},
      {'icon': Icons.compare_arrows, 'label': 'Entre contas', 'widget': const TransferCard()},
    ];

    final initialWidget = actions[selectedIndex]['widget'] as Widget?;
    if (initialWidget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelect(initialWidget);
      });
    }
  }

  void _scrollToIndex(int index) {
    final offset = index * (kItemWidth + kSeparator);
    _scrollController.animateTo(
      offset.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: .horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: kSeparator),
        itemBuilder: (context, index) {
          final action = actions[index];
          final enabled = index == selectedIndex;
          final widgetToShow = action['widget'] as Widget?;

          return _buildActionItem(
            context,
            action['icon'] as IconData,
            action['label'] as String,
            isEnabled: enabled,
            onTap: widgetToShow != null
                ? () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onSelect(widgetToShow);
                    _scrollToIndex(index);
                  }
                : null,
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
    VoidCallback? onTap,
  }) {
    final color = isEnabled ? AppColors.primary : AppColors.secondary;
    final iconColor = isEnabled ? AppColors.white : AppColors.iconDisable;

    return SizedBox(
      width: kItemWidth,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          Material(
            color: AppColors.transparent,
            borderRadius: .circular(16),
            child: Ink(
              width: kIconBoxSize,
              height: kIconBoxSize,
              decoration: BoxDecoration(color: color, borderRadius: .circular(16)),
              child: InkWell(
                borderRadius: .circular(16),
                onTap: onTap,
                child: Center(child: Icon(icon, color: iconColor, size: 28)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: .center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: .w500, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
