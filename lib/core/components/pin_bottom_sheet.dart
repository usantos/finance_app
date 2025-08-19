import 'package:flutter/material.dart';
import 'package:financial_app/core/components/textfield_pin.dart';

import 'custom_bottom_sheet.dart';

class PinBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required void Function(String pin) onCompleted,
    VoidCallback? onCancel,
  }) async {
    await CustomBottomSheet.show(
      context,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextFieldPin(
            length: 4,
            onComplete: (value) async {
              FocusScope.of(context).unfocus();
              onCompleted(value);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
              if (onCancel != null) onCancel();
            },
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
