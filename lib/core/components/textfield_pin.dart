import 'dart:async';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class TextFieldPin extends StatefulWidget {
  final Function(String value)? onStateChanged;
  final FutureOr<void> Function(String value) onComplete;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enableActiveFill;
  final bool obscureText;
  final bool isEnabled;
  final int length;
  final double height;
  final double width;

  const TextFieldPin({
    super.key,
    this.controller,
    required this.onComplete,
    this.obscureText = false,
    this.onStateChanged,
    this.enableActiveFill = false,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.isEnabled = true,
    this.focusNode,
    this.height = 63,
    this.length = 6,
    this.width = 44,
  });

  @override
  TextFieldPinState createState() => TextFieldPinState();
}

class TextFieldPinState extends State<TextFieldPin> {
  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: widget.width,
      height: widget.height,
      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: AppColors.black),
      decoration: BoxDecoration(border: Border.all(color: AppColors.secondary)),
    );

    return Pinput(
      controller: widget.controller,
      focusNode: widget.focusNode,
      length: widget.length,
      defaultPinTheme: pinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      enabled: widget.isEnabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      obscureText: widget.obscureText,
      animationDuration: Durations.short4,
      onCompleted: (value) async {
        await widget.onComplete.call(value);
      },
      onChanged: (value) {
        widget.onStateChanged?.call(value);
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(margin: const EdgeInsets.only(bottom: 9), width: 32, height: 1, color: AppColors.secondary),
        ],
      ),
      focusedPinTheme: pinTheme.copyWith(
        decoration: pinTheme.decoration!.copyWith(border: Border.all(color: AppColors.secondary)),
      ),
    );
  }
}
