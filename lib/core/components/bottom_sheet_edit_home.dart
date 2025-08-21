import 'package:flutter/material.dart';

class BottomSheetEditHome extends StatefulWidget {
  const BottomSheetEditHome({super.key});

  @override
  State<BottomSheetEditHome> createState() => _BottomSheetEditHomeState();
}

class _BottomSheetEditHomeState extends State<BottomSheetEditHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.black, size: 30),
          ),
        ),
        const SizedBox(height: 18),
        const Text("Dados bancários", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Numero da conta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("12345-8**", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 40),
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
              icon: const Icon(Icons.edit, color: Colors.black, size: 30),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 40),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Senha de transferência", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("****", style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.black, size: 30),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 40),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nome no aplicativo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Jão", style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.black, size: 30),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 40),
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
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.black, size: 30),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], height: 40),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Finance Pagamentos LTDA-\nInstituição de Pagamentos ",
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
