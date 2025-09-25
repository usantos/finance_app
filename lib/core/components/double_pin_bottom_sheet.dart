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
  }) async {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final errorNotifierOldPassword = ValueNotifier<String?>(null);
    final errorNotifierNewPassword = ValueNotifier<String?>(null);
    final obscureNotifier = ValueNotifier<bool>(obscureText);

    oldController.addListener(() {
      if (oldController.text.isNotEmpty) {
        errorNotifierOldPassword.value = null;
      }
    });
    newController.addListener(() {
      if (newController.text.isNotEmpty) {
        errorNotifierNewPassword.value = null;
      }
    });

    void confirmPins() {
      final oldPin = oldController.text.trim();
      final newPin = newController.text.trim();

      bool hasError = false;

      if (oldPin.isEmpty || oldPin.length != pinLength) {
        errorNotifierOldPassword.value = "Digite os $pinLength dígitos";
        hasError = true;
      }
      if (newPin.isEmpty || newPin.length != pinLength) {
        errorNotifierNewPassword.value = "Digite os $pinLength dígitos";
        hasError = true;
      }
      if (hasError) return;

      if (newPin.split('').toSet().length == 1) {
        errorNotifierNewPassword.value = "Não pode usar números repetidos";
        hasError = true;
      }
      if (hasError) return;

      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
      onCompleted(oldPin, newPin);
    }

    await CustomBottomSheet.show(
      context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      iconClose: false,
      height: MediaQuery.of(context).size.height * 0.750,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                  ValueListenableBuilder<bool>(
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
                ],
              ),
              Text(
                titleOld,
                textAlign: TextAlign.center,
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
              ValueListenableBuilder<String?>(
                valueListenable: errorNotifierOldPassword,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 14)),
                  );
                },
              ),
              SizedBox(height: spacing * 1.5),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("• Use pelo menos 4 caracteres.", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "• Não inclua dígitos do seu cpf, data de nascimento ou número de celular.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Text(
                titleNew,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: titleFontSize, fontWeight: titleFontWeight, color: titleColor),
              ),
              SizedBox(height: spacing),
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
              ValueListenableBuilder<String?>(
                valueListenable: errorNotifierNewPassword,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    ),
                    onPressed: confirmPins,
                    child: const Text("Confirmar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
