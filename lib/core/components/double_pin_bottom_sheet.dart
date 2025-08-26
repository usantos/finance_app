import 'package:flutter/material.dart';
import 'package:financial_app/core/components/textfield_pin.dart';
import 'custom_bottom_sheet.dart';

class DoublePinBottomSheet {
  static Future<void> showDouble(
    BuildContext context, {
    required String titleOld,
    required String titleNew,
    required void Function(String oldTransferPassword, String newTransferPassword) onCompleted,
    double? width,
    double spacing = 20,
    double titleFontSize = 20,
    Color titleColor = Colors.black,
    FontWeight titleFontWeight = FontWeight.bold,
    int pinLength = 4,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    bool obscureText = true,
    bool autoSubmitOnComplete = true,
    bool isDismissible = false,
    bool enableDrag = false,
    bool iconClose = true,
  }) async {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final errorNotifier = ValueNotifier<String?>(null);
    final obscureNotifier = ValueNotifier<bool>(obscureText);

    void confirmPins() {
      final oldPin = oldController.text.trim();
      final newPin = newController.text.trim();

      if (oldPin.length != pinLength || newPin.length != pinLength) {
        errorNotifier.value = "Digite os $pinLength dígitos em ambos os campos";
        return;
      }

      if (oldPin.split('').toSet().length == 1 || newPin.split('').toSet().length == 1) {
        errorNotifier.value = "Não pode usar números repetidos";
        return;
      }

      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
      onCompleted(oldPin, newPin);
    }

    await CustomBottomSheet.show(
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      iconClose: iconClose,
      context,
      width: width ?? MediaQuery.of(context).size.width,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ValueListenableBuilder<bool>(
                  valueListenable: obscureNotifier,
                  builder: (context, isObscured, _) {
                    return IconButton(
                      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        obscureNotifier.value = !obscureNotifier.value;
                      },
                    );
                  },
                ),
              ),
              Text(
                titleOld,
                style: TextStyle(fontSize: titleFontSize, fontWeight: titleFontWeight, color: titleColor),
              ),
              SizedBox(height: spacing),
              ValueListenableBuilder<bool>(
                valueListenable: obscureNotifier,
                builder: (context, isObscured, _) {
                  return TextFieldPin(
                    obscureText: isObscured,
                    controller: oldController,
                    length: pinLength,
                    keyboardType: TextInputType.number,
                    onComplete: (_) {
                      if (autoSubmitOnComplete) confirmPins();
                    },
                  );
                },
              ),
              SizedBox(height: spacing * 1.5),

              Text(
                titleNew,
                style: TextStyle(fontSize: titleFontSize, fontWeight: titleFontWeight, color: titleColor),
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: obscureNotifier,
                    builder: (context, isObscured, _) {
                      return TextFieldPin(
                        obscureText: isObscured,
                        controller: newController,
                        length: pinLength,
                        keyboardType: TextInputType.number,
                        onComplete: (_) {
                          if (autoSubmitOnComplete) confirmPins();
                        },
                      );
                    },
                  ),
                ],
              ),

              ValueListenableBuilder<String?>(
                valueListenable: errorNotifier,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 14)),
                  );
                },
              ),

              SizedBox(height: spacing),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                  ),
                  FilledButton(onPressed: confirmPins, child: const Text("Confirmar")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
