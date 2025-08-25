import 'package:flutter/material.dart';
import 'package:financial_app/core/components/textfield_pin.dart';
import 'custom_bottom_sheet.dart';

class PinBottomSheet {
  static Future<void> show(
      BuildContext context, {
        required String title,
        required void Function(String pin) onCompleted,
        double? width,
        double spacing = 20,
        double titleFontSize = 20,
        Color titleColor = Colors.black,
        FontWeight titleFontWeight = FontWeight.bold,
        int pinLength = 4,
        EdgeInsetsGeometry padding = const EdgeInsets.all(16),
        List<Widget>? extraActions,
        bool autoSubmitOnComplete = true,
        bool obscureText = true,
      }) async {
    final controller = TextEditingController();
    final errorNotifier = ValueNotifier<String?>(null);
    final obscureNotifier = ValueNotifier<bool>(obscureText);

    void confirmPin() {
      final pin = controller.text.trim();

      if (pin.length != pinLength) {
        errorNotifier.value = "Digite os $pinLength dígitos";
        return;
      }

      if (pin.split('').toSet().length == 1) {
        errorNotifier.value = "Não pode usar números repetidos";
        return;
      }

      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
      onCompleted(pin);
    }

    await CustomBottomSheet.show(
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
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: titleFontWeight,
                      color: titleColor,
                    ),
              ),
              SizedBox(height: spacing),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: obscureNotifier,
                builder: (context, isObscured, _) {
                  return TextFieldPin(
                    obscureText: isObscured,
                    controller: controller,
                    length: pinLength,
                    keyboardType: TextInputType.number,
                    onComplete: (_) {
                      if (autoSubmitOnComplete) confirmPin();
                    },
                  );
                },
              ),
                    SizedBox(width: 30,),
                ValueListenableBuilder<bool>(
                  valueListenable: obscureNotifier,
                  builder: (context, isObscured, _) {
                    return IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        obscureNotifier.value = !obscureNotifier.value;
                      },
                    );
                  },
                ),
              ]),
              ValueListenableBuilder<String?>(
                valueListenable: errorNotifier,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
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
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  FilledButton(onPressed: confirmPin, child: const Text("Confirmar")),
                  if (extraActions != null) ...extraActions,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
