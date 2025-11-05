import 'package:another_flushbar/flushbar.dart';
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
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.black, size: 20),
                ),
              ),
              const Text(
                "Dados bancários",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nome",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      Text(
                        "${authVM.currentUser?.user.name}",
                        style: const TextStyle(fontSize: 16, color: AppColors.blackText),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              Divider(color: AppColors.grey, height: 38),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Telefone",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      Text(
                        authVM.currentUser?.user.phone.maskPhoneMid() ?? '-',
                        style: const TextStyle(fontSize: 16, color: AppColors.blackText),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              Divider(color: AppColors.grey, height: 38),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Senha",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      const Text("****", style: TextStyle(fontSize: 16, color: AppColors.blackText)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              Divider(color: AppColors.grey, height: 38),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Senha de transferência",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      Text("****", style: TextStyle(fontSize: 16, color: AppColors.blackText)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
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
                          Flushbar(
                            message: success
                                ? 'Senha alterada com sucesso'
                                : (_transactionVM.errorMessage ?? 'Erro ao alterar senha'),
                            duration: const Duration(seconds: 3),
                            backgroundColor: success ? AppColors.greenSuccess : AppColors.redError,
                            margin: const EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(8),
                            flushbarPosition: FlushbarPosition.BOTTOM,
                          ).show(context);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, color: AppColors.black, size: 25),
                  ),
                ],
              ),

              Divider(color: AppColors.grey, height: 38),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Close Finance Pagamentos LTDA-\nInstituição de Pagamentos ",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
