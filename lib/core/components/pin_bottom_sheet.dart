import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/core/components/textfield_pin.dart';
import 'custom_bottom_sheet.dart';

class PinBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required void Function(String pin) onCompleted,
    double? width,
    double? height,
    double spacing = 20,
    double titleFontSize = 20,
    Color titleColor = AppColors.black,
    FontWeight titleFontWeight = .bold,
    int pinLength = 4,
    EdgeInsetsGeometry padding = const .all(16),
    List<Widget>? extraActions,
    bool autoSubmitOnComplete = true,
    bool obscureText = true,
    bool isDismissible = false,
    bool enableDrag = false,
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
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      iconClose: false,
      height: height ?? MediaQuery.of(context).size.height * 0.4,
      width: width ?? MediaQuery.of(context).size.width,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: obscureNotifier,
                    builder: (context, isObscured, _) {
                      return IconButton(
                        icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: AppColors.black),
                        onPressed: () {
                          obscureNotifier.value = !obscureNotifier.value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                title,
                textAlign: .center,
                style: TextStyle(fontSize: titleFontSize, fontWeight: titleFontWeight, color: titleColor),
              ),
              SizedBox(height: spacing),
              ValueListenableBuilder<bool>(
                valueListenable: obscureNotifier,
                builder: (context, isObscured, _) {
                  return TextFieldPin(
                    obscureText: isObscured,
                    controller: controller,
                    length: pinLength,
                    keyboardType: .number,
                    onComplete: (_) {
                      if (autoSubmitOnComplete) confirmPin();
                    },
                  );
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: errorNotifier,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const .only(top: 8),
                    child: Text(errorText, style: const TextStyle(color: AppColors.red, fontSize: 14)),
                  );
                },
              ),
              SizedBox(height: spacing),
              if (!autoSubmitOnComplete)
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(7),
                          side: const BorderSide(color: AppColors.black),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancelar", style: TextStyle(color: AppColors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(7),
                          side: const BorderSide(color: AppColors.black),
                        ),
                      ),
                      onPressed: confirmPin,
                      child: const Text("Confirmar", style: TextStyle(color: AppColors.white)),
                    ),
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
