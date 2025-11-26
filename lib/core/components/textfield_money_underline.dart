import 'package:financial_app/core/extensions/double_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldMoneyUnderline extends StatefulWidget {
  const TextFieldMoneyUnderline({
    super.key,
    this.fontSize = 32.0,
    required this.maxValue,
    this.minValue = 0.00,
    required this.onValidationChanged,
    required this.onComplete,
    this.onFocus,
  });

  final double fontSize;
  final double maxValue;
  final double minValue;
  final void Function(bool) onValidationChanged;
  final void Function(double) onComplete;
  final void Function(bool)? onFocus;

  @override
  MonetaryInputFieldState createState() => MonetaryInputFieldState();
}

class MonetaryInputFieldState extends State<TextFieldMoneyUnderline> {
  final TextEditingController _amountController = .new();
  final FocusNode _focusNode = FocusNode();
  Color _textColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      onValidate();
    });
    _focusNode.addListener(() {
      if (widget.onFocus != null) {
        widget.onFocus!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onValidate() {
    String receivedValue = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (receivedValue.isEmpty) receivedValue = '0';

    final double number = receivedValue.isEmpty ? 0 : double.parse(receivedValue) / 100;

    bool isValid = false;

    if (number > widget.minValue && number <= widget.maxValue) {
      _textColor = AppColors.primary;
      isValid = true;
    } else if (number > widget.maxValue) {
      _textColor = AppColors.red;
      isValid = false;
    } else if (number == 0.00) {
      _textColor = AppColors.primary;
      isValid = false;
    } else {
      _textColor = AppColors.red;
      isValid = false;
    }

    setState(() {
      _amountController.value = _amountController.value.copyWith(
        text: number.toMoneyFormatter(),
        selection: TextSelection.collapsed(offset: number.toMoneyFormatter().length),
      );
    });

    widget.onValidationChanged(isValid);
    if (isValid) {
      widget.onComplete(number);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      enableInteractiveSelection: false,
      cursorErrorColor: AppColors.primary,
      cursorColor: AppColors.primary,
      maxLength: 9,
      controller: _amountController,
      keyboardType: .number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
        counterText: '',
        hintText: r'R$ 0,00',
        hintStyle: TextStyle(color: AppColors.primary),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
      ),
      style: TextStyle(fontSize: widget.fontSize, fontWeight: .w800, color: _textColor),
    );
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  void setValue(double value) {
    setState(() {
      _amountController.text = value.toMoneyFormatter();
      onValidate();
    });
  }
}
