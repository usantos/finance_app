import 'package:financial_app/core/components/bottom_sheet_edit_home.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetMain extends StatefulWidget {
  const BottomSheetMain({super.key});

  @override
  State<BottomSheetMain> createState() => _BottomSheetMainState();
}

class _BottomSheetMainState extends State<BottomSheetMain> {
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
                  context,
                  isFull: true,
                  width: MediaQuery.of(context).size.width,
                  isDismissible: true,
                  enableDrag: true,
                  child: const BottomSheetEditHome(),
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
                  userName!,
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
