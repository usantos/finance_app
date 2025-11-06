import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottom_sheet_recharge_phone_2.dart';

class BottomSheetRechargePhone1 extends StatefulWidget {
  const BottomSheetRechargePhone1({super.key});

  @override
  State<BottomSheetRechargePhone1> createState() => _BottomSheetRechargePhone1State();
}

class _BottomSheetRechargePhone1State extends State<BottomSheetRechargePhone1> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  int? _selectedIndex;
  String _rawPhone = "";
  final List<String> _operators = ["Vivo", "Tim", "Claro", "Oi"];

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            Text("Qual número deseja recarregar", style: TextStyle(color: AppColors.black, fontSize: 18)),
            SizedBox(height: 14),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 11,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              controller: _phoneController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                filled: true,
                fillColor: AppColors.greyBackground,
                hintText: '(00) 00000-0000',
                labelText: 'Número',
                labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                prefixIcon: const Icon(Icons.phone, size: 18, color: AppColors.black),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
              validator: Utils.validatePhone,
              onChanged: (value) {
                _rawPhone = value.replaceAll(RegExp(r'\D'), '');
                setState(() {
                  _phoneController.text = _rawPhone.toPhone();
                });
              },
            ),
            SizedBox(height: 18),
            Text("Escolha a operadora", style: TextStyle(color: AppColors.black, fontSize: 18)),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildOperatorItem(0), _buildOperatorItem(1)],
                ),
                const SizedBox(width: 60),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildOperatorItem(2), _buildOperatorItem(3)],
                ),
              ],
            ),
            if (_selectedIndex != null && _formKey.currentState!.validate())
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    CustomBottomSheet.show(context, height: 390, child: BottomSheetRechargePhone2());
                  },
                  icon: Icon(Icons.arrow_forward, color: AppColors.black),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorItem(int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              child: Center(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(_operators[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
