import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/services/transfer_password_service.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSheetEditPhone extends StatefulWidget {
  const BottomSheetEditPhone({super.key});

  @override
  State<BottomSheetEditPhone> createState() => _BottomSheetEditPhoneState();
}

class _BottomSheetEditPhoneState extends State<BottomSheetEditPhone> {
  final authVM = sl.get<AuthViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  String _rawPhone = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Digite o novo número de telefone", style: TextStyle(color: AppColors.black, fontSize: 18)),
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
                  _phoneController.selection = TextSelection.collapsed(offset: _phoneController.text.length);
                });
              },
            ),
            SizedBox(height: 14),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await TransferPasswordService.showAndHandle(
                        context: context,
                        onSuccess: () async {
                          final success = await authVM.setNewPhoneNumber(_rawPhone);
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authVM.errorMessage ?? 'Erro ao atualizar o número de telefone'),
                                backgroundColor: AppColors.redError,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Número de telefone atualizado com sucesso!'),
                                backgroundColor: AppColors.greenSuccess,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }

                          if (mounted) {
                            _phoneController.clear();
                            _phoneFocusNode.unfocus();
                            closeTwoSheets(context);
                          }
                        },
                      );
                    }
                  },
                  child: const Text("Confirmar", style: TextStyle(color: AppColors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void closeTwoSheets(BuildContext context) {
    final nav = Navigator.of(context, rootNavigator: true);
    nav.pop();
    nav.pop();
  }
}
