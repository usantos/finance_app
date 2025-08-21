import 'package:financial_app/core/components/bottom_sheet_edit_home.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetMain extends StatefulWidget {
  const BottomSheetMain({super.key});

  @override
  State<BottomSheetMain> createState() => _BottomSheetMainState();
}

class _BottomSheetMainState extends State<BottomSheetMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black, size: 30),
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
                icon: const Icon(Icons.edit, color: Colors.black, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const Image(image: AssetImage('assets/avatar_placeholder.png'), width: 50, height: 50),
              const SizedBox(width: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Teste",
                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Conta: 12345-6",
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
