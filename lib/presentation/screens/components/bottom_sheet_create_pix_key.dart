import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/screens/components/teste_adicionar_pix_key.dart';
import 'package:flutter/material.dart';

class BottomSheetCreatePixKey extends StatefulWidget {
  const BottomSheetCreatePixKey({super.key});

  @override
  State<BottomSheetCreatePixKey> createState() => _BottomSheetCreatePixKeyState();
}

class _BottomSheetCreatePixKeyState extends State<BottomSheetCreatePixKey> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.phone_android, color: AppColors.black, size: 25),
            SizedBox(width: 12),

            const Text(
              "Telefone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
            ),

            const Spacer(),
            IconButton(
              onPressed: () {
                showTwoFieldBottomSheet(context);
              },
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.credit_card, color: AppColors.black, size: 25),
            SizedBox(width: 12),

            const Text(
              "CPF",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
            ),

            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.email_outlined, color: AppColors.black, size: 25),
            SizedBox(width: 12),

            const Text(
              "Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
            ),

            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.black, size: 25),
            SizedBox(width: 12),

            const Text(
              "Chave aleatória",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
            ),

            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
      ],
    );
  }
}
