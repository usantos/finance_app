import 'package:financial_app/core/components/template.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomSheetBlockCreditCard extends StatefulWidget {
  const BottomSheetBlockCreditCard({super.key});

  @override
  State<BottomSheetBlockCreditCard> createState() => _BottomSheetBlockCreditCardState();
}

class _BottomSheetBlockCreditCardState extends State<BottomSheetBlockCreditCard> {
  @override
  void initState() {
    super.initState();
  }

  void _openTemplate({
    required String title,
    required String typeTitle,
    required String buttonText,
    String? description,
    String? footerDescription,
    TextEditingController? controller,
    required Widget body,
    required String method,
  }) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateScreen(
          title: title,
          typeTitle: typeTitle,
          buttonText: buttonText,
          description: description,
          footerDescription: footerDescription,
          textController: controller,
          body: body,
          method: method,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Escolha o tipo de bloqueio que deseja fazer",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        const SizedBox(height: 30),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _openTemplate(
              title: 'Bloqueio Definitivo',
              typeTitle: 'BLOCKED_DEF',
              buttonText: 'Confirmar',
              method: 'Block',
              body: Center(
                heightFactor: 1.6,
                child: Text(
                  'O bloqueio definitivo é permanente. \nApós confirmar, este cartão não poderá mais ser utilizado, e será necessário solicitar um novo para voltar a usar.\n\nTem certeza de que deseja continuar?',
                  style: TextStyle(fontSize: 18, color: AppColors.black),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Text("Bloqueio Definitivo", style: TextStyle(fontSize: 18, color: AppColors.black)),
                Spacer(),
                Icon(Icons.chevron_right, color: AppColors.black, size: 25),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _openTemplate(
              title: 'Bloqueio Temporário',
              typeTitle: 'BLOCKED_TMP',
              buttonText: 'Confirmar',
              method: 'Block',
              body: Center(
                heightFactor: 1.6,
                child: Text(
                  'O bloqueio temporário é reversível. \n'
                  'Ele serve para impedir o uso momentâneo do cartão ou conta, por exemplo, se você não a estiver utilizando agora. \n\n'
                  'Você pode desbloquear a qualquer momento.',
                  style: TextStyle(fontSize: 18, color: AppColors.black),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Text("Bloqueio Temporário", style: TextStyle(fontSize: 18, color: AppColors.black)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.black, size: 25),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
