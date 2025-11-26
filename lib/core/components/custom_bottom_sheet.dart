import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    double? height,
    double? width,
    bool isFull = false,
    bool isDismissible = false,
    bool enableDrag = false,
    bool iconClose = false,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      builder: (context) => Padding(
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            top: false,
            child: Container(
              height: isFull ? MediaQuery.of(context).size.height * 0.92 : height,
              width: width,
              padding: const .all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: .vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const .only(bottom: 12),
                    decoration: BoxDecoration(color: AppColors.black, borderRadius: .circular(2)),
                  ),
                  if (iconClose)
                    Row(
                      mainAxisAlignment: .start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppColors.black, size: 20),
                        ),
                      ],
                    ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Column(mainAxisSize: .min, children: [child]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
