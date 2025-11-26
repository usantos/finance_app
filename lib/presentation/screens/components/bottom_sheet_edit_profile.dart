import 'package:financial_app/core/components/double_pin_bottom_sheet.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetEditProfile extends StatefulWidget {
  const BottomSheetEditProfile({super.key});

  @override
  State<BottomSheetEditProfile> createState() => _BottomSheetEditProfileState();
}

class _BottomSheetEditProfileState extends State<BottomSheetEditProfile> {
  final _transactionVM = sl.get<TransactionViewModel>();
  final _authVM = sl.get<AuthViewModel>();
  final _accountVM = sl.get<AccountViewModel>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authVM.checkCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authVM),
        ChangeNotifierProvider.value(value: _accountVM),
      ],
      child: Consumer2<AuthViewModel, AccountViewModel>(
        builder: (context, authVM, accountVM, _) {
          return Column(
            children: [
              Align(
                alignment: .topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.black, size: 20),
                ),
              ),
              const Text(
                "Dados pessoais",
                style: TextStyle(fontSize: 20, fontWeight: .bold, color: AppColors.black),
              ),
              const SizedBox(height: 18),
              _rows(title: "Nome", value: authVM.currentUser?.user.name ?? ""),
              Divider(color: AppColors.grey, height: 36),
              _rows(title: "Telefone", value: authVM.currentUser?.user.phone.maskPhoneMid() ?? ""),
              Divider(color: AppColors.grey, height: 36),
              _rows(title: "Senha do aplicativo", value: "****"),
              Divider(color: AppColors.grey, height: 36),
              _rows(
                title: "Senha de transferência",
                value: "****",
                onTap: () async {
                  await DoublePinBottomSheet.showDouble(
                    autoSubmitOnComplete: false,
                    context,
                    titleOld: "Senha de transferência atual",
                    titleNew: "Nova senha de transferência",
                    onCompleted: (oldTransferPassword, newTransferPassword) async {
                      final success = await _transactionVM.changeTransferPassword(
                        oldTransferPassword,
                        newTransferPassword,
                      );

                      if (!success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_transactionVM.errorMessage ?? 'Erro ao alterar senha'),
                            backgroundColor: AppColors.redError,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Senha alterada com sucesso!'),
                            backgroundColor: AppColors.greenSuccess,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              Divider(color: AppColors.grey, height: 36),
              _rows(title: "Close Finance Pagamentos LTDA-\nInstituição de Pagamentos"),
            ],
          );
        },
      ),
    );
  }

  Widget _rows({required String title, String? value, VoidCallback? onTap}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
            ),
            Text(value ?? "", maxLines: 1, style: const TextStyle(fontSize: 16, color: AppColors.blackText)),
          ],
        ),
        const Spacer(),
        onTap != null
            ? IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.edit, color: AppColors.black, size: 25),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
