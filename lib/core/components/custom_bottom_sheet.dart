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
    bool iconClose = true,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: isFull ? MediaQuery.of(context).size.height * 0.920 : height,
            width: width,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  iconClose ?
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.black, size: 20),
                    ),
                  ) : const SizedBox.shrink(),
                  child,
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
