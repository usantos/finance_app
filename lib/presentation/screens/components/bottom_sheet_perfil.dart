import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/screens/components/bottom_sheet_home_edit.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetPerfil extends StatefulWidget {
  const BottomSheetPerfil({super.key});

  @override
  State<BottomSheetPerfil> createState() => _BottomSheetPerfilState();
}

class _BottomSheetPerfilState extends State<BottomSheetPerfil> {
  String? userName;
  String? accountNumber;
  final _authViewModel = sl.get<AuthViewModel>();
  final _accountViewModel = sl.get<AccountViewModel>();

  @override
  initState() {
    super.initState();
    accountNumber = _accountViewModel.account?.accountNumber;
    userName = _authViewModel.currentUser?.username;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.black, size: 20),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                CustomBottomSheet.show(
                  iconClose: false,
                  context,
                  isFull: true,
                  width: MediaQuery.of(context).size.width,
                  isDismissible: true,
                  enableDrag: true,
                  child: const BottomSheetHomeEdit(),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Image(image: AssetImage('assets/avatar_placeholder.png'), width: 50, height: 50),
            const SizedBox(width: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //userName!,
                  "JAO",
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Conta: $accountNumber",
                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
