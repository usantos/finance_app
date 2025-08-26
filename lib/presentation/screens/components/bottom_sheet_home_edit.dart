import 'package:another_flushbar/flushbar.dart';
import 'package:financial_app/core/components/double_pin_bottom_sheet.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetHomeEdit extends StatefulWidget {
  const BottomSheetHomeEdit({super.key});

  @override
  State<BottomSheetHomeEdit> createState() => _BottomSheetHomeEditState();
}

class _BottomSheetHomeEditState extends State<BottomSheetHomeEdit> {
  String? userName;
  String? accountNumber;

  @override
  initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
    accountNumber = accountViewModel.account?.accountNumber;
    userName = authViewModel.currentUser?.username;
  }

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ),
        const Text("Dados bancários", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Numero da conta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("$accountNumber", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 38),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Senha", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("****", style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.black, size: 25),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 38),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Senha de transferência", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("****", style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                await DoublePinBottomSheet.showDouble(
                  iconClose: false,
                  autoSubmitOnComplete: false,
                  context,
                  titleOld: "Digite sua senha de transferência atual",
                  titleNew: "Digite sua nova senha de transferência",
                  onCompleted: (oldTransferPassword, newTransferPassword) async {
                    final success = await transactionViewModel.changeTransferPassword(
                      oldTransferPassword,
                      newTransferPassword,
                    );
                    Flushbar(
                      message: success
                          ? 'Senha alterada com sucesso'
                          : (transactionViewModel.errorMessage ?? 'Erro ao alterar senha'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: success ? Colors.green : Colors.red,
                      margin: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      flushbarPosition: FlushbarPosition.BOTTOM,
                    ).show(context);
                  },
                );
              },
              icon: const Icon(Icons.edit, color: Colors.black, size: 25),
            ),
          ],
        ),

        Divider(color: Colors.grey[300], height: 38),
        const Text("Dados do aplicativo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nome", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("$userName", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.black, size: 25),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 38),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Foto de perfil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Image(image: AssetImage('assets/avatar_placeholder.png'), height: 40),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.edit, color: Colors.black, size: 25),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 38),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Close Finance Pagamentos LTDA-\nInstituição de Pagamentos ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
